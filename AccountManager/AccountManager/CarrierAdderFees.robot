*** Settings ***
Documentation  These is a comprehensive test for Carrier Adder Fees
...  Runs through Carrier, Contract, Parent carrier adder fees
...  it could run for each one of those it then test issuer type, site type,
...  filter type, product type, and fee type in its many different
...  combinations. But to save time it just tests the basic.
Library  DateTime
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.ws.CardManagementWS
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/AuthKeywords.robot

Suite Setup  time to setup
Suite Teardown  clean up

Force Tags  Auth  AM  refactor

*** Variables ***
${location}=  502434
${dbyesterday}
${dbtomorrow}
${webtomorrow}
${webnextday}
${start}
#the below variables had position 0 as filler so working through the nested for loop is easier
@{owner}  filler  700104  1323110  700001
@{card}  filler  5014861100908100300  5014861100908100326  5014861119781600087
${adderfee}  .01
${FEETYPE}
${productTypeId}
${matches}
${siteTypeId}
${issuerTypeId}
${ownerTypeId}

*** Test Cases ***
########################  Owner ID as CARRIER  ##############################
######################  All Issuers ALL Location  ###########################
CARRIER ALL ISSUERS ALL LOCATIONS ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  qTest:32672465  qTest:32672769  qtest:32674381  qtest:32675506  qtest:32675542  Regression  CARRIER  ALL ISSUERS  ALL LOCATIONS  ALL PRODUCTS  EXTENDED TERMS FEE
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product
    run transaction  ${card[${ownerTypeId}]}  ${string}
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS ALL LOCATIONS ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  qTest:32674381  Regression  indepthadder  CARRIER  ALL ISSUERS  ALL LOCATIONS  ALL PRODUCTS  IN NETWORK FEE
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product
    run transaction  ${card[${ownerTypeId}]}  ${string}
    [Teardown]  Delete fee  ${owner[${ownerTypeId}]}

CARRIER ALL ISSUERS ALL LOCATIONS ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  ALL LOCATIONS  ALL PRODUCTS  OUT OF NETWORK FEE
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS ALL LOCATIONS ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  ALL LOCATIONS  ALL PRODUCTS  MISC ADDER FEE
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS ALL LOCATIONS CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  ALL LOCATIONS  CASH ADVANCE ONLY  EXTENDED TERMS FEE 
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS ALL LOCATIONS CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  ALL LOCATIONS  CASH ADVANCE ONLY  IN NETWORK FEE 
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS ALL LOCATIONS CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  ALL LOCATIONS  CASH ADVANCE ONLY  OUT OF NETWORK FEE 
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS ALL LOCATIONS CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  ALL LOCATIONS  CASH ADVANCE ONLY  MISC ADDER FEE 
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS ALL LOCATIONS FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  ALL LOCATIONS  FUEL ONLY  EXTENDED TERMS FEE 
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS ALL LOCATIONS FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  ALL LOCATIONS  FUEL ONLY  IN NETWORK FEE 
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS ALL LOCATIONS FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  ALL LOCATIONS  FUEL ONLY  OUT OF NETWORK FEE 
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS ALL LOCATIONS FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  ALL LOCATIONS  FUEL ONLY  MISC ADDER FEE 
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS ALL LOCATIONS FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  ALL LOCATIONS  FUEL & CASH  EXTENDED TERMS FEE 
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS ALL LOCATIONS FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  ALL LOCATIONS  FUEL & CASH  IN NETWORK FEE 
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS ALL LOCATIONS FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  ALL LOCATIONS  FUEL & CASH  OUT OF NETWORK FEE 
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS ALL LOCATIONS FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  ALL LOCATIONS  FUEL & CASH  MISC ADDER FEE 
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

######################  All Issuers SPECIFIC Location  ###########################
CARRIER ALL ISSUERS SPECIFIC LOCATION ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  qTest:32674503  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC LOCATION  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC LOCATION ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC LOCATION  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC LOCATION ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC LOCATION  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC LOCATION ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC LOCATION  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC LOCATION CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC LOCATION  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC LOCATION CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  qTest:32674503  qTest:32675511  qTest:32676282  CARRIER  ALL ISSUERS  SPECIFIC LOCATION  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC LOCATION CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC LOCATION  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC LOCATION CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC LOCATION  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC LOCATION FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC LOCATION  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC LOCATION FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC LOCATION  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC LOCATION FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC LOCATION  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC LOCATION FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC LOCATION  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC LOCATION FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC LOCATION  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC LOCATION FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC LOCATION  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC LOCATION FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC LOCATION  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC LOCATION FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC LOCATION  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

######################  All Issuers Exclude Specific Location  ###########################
CARRIER ALL ISSUERS EXCLUDES SPECIFIC LOCATION ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  qTest:32674579  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  ALL PRODUCTS  EXTENDED TERMS FEE
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC LOCATION ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC LOCATION ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC LOCATION ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  qTest:32674579  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC LOCATION CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC LOCATION CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC LOCATION CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC LOCATION CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC LOCATION FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC LOCATION FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC LOCATION FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC LOCATION FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC LOCATION FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC LOCATION FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC LOCATION FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC LOCATION FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}
       
######################  All Issuers Specific Supplier  ###########################
CARRIER ALL ISSUERS SPECIFIC SUPPLIER ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  qTest:32674652  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC SUPPLIER  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC SUPPLIER ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC SUPPLIER  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC SUPPLIER ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC SUPPLIER  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC SUPPLIER ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC SUPPLIER  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC SUPPLIER CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC SUPPLIER CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC SUPPLIER CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC SUPPLIER CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC SUPPLIER FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC SUPPLIER  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC SUPPLIER FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC SUPPLIER  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC SUPPLIER FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  qTest:32674652  qTest:32676295  qTest:32675518  CARRIER  ALL ISSUERS  SPECIFIC SUPPLIER  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC SUPPLIER FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC SUPPLIER  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC SUPPLIER FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC SUPPLIER  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC SUPPLIER FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC SUPPLIER  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC SUPPLIER FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC SUPPLIER  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC SUPPLIER FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC SUPPLIER  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

######################  All Issuers excludes Specific Supplier  ###########################
CARRIER ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  qTest:32674703  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  qTest:32674703  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

######################  All Issuers Specific Chain  ###########################
CARRIER ALL ISSUERS SPECIFIC CHAIN ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  qTest:32674761  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC CHAIN  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC CHAIN ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC CHAIN  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC CHAIN ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC CHAIN  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC CHAIN ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC CHAIN  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC CHAIN CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC CHAIN  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC CHAIN CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC CHAIN  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC CHAIN CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC CHAIN  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC CHAIN CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC CHAIN  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC CHAIN FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC CHAIN  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC CHAIN FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC CHAIN  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC CHAIN FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC CHAIN  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC CHAIN FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC CHAIN  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC CHAIN FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC CHAIN  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC CHAIN FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC CHAIN  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC CHAIN FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC CHAIN  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC CHAIN FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  qTest:32674761  qTest:32675521  qTest:32676296  CARRIER  ALL ISSUERS  SPECIFIC CHAIN  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[1]}

######################  All Issuers Exclude Specific Chain  ###########################
CARRIER ALL ISSUERS EXCLUDES SPECIFIC CHAIN ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  qTest:32674936  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC CHAIN ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC CHAIN ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC CHAIN ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC CHAIN CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC CHAIN CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC CHAIN CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC CHAIN CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC CHAIN FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC CHAIN FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  qTest:32674936  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC CHAIN FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC CHAIN FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC CHAIN FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC CHAIN FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC CHAIN FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC CHAIN FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}
    
######################  All Issuers Specific Association  ###########################
CARRIER ALL ISSUERS SPECIFIC ASSOCIATION ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  qTest:32675482  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC ASSOCIATION  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC ASSOCIATION ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  qTest:32675482  CARRIER  ALL ISSUERS  SPECIFIC ASSOCIATION  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC ASSOCIATION ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC ASSOCIATION  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC ASSOCIATION ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC ASSOCIATION  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC ASSOCIATION FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC ASSOCIATION  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC ASSOCIATION FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC ASSOCIATION  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC ASSOCIATION FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC ASSOCIATION  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC ASSOCIATION FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC ASSOCIATION  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC ASSOCIATION FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC ASSOCIATION  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC ASSOCIATION FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC ASSOCIATION  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC ASSOCIATION FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC ASSOCIATION  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS SPECIFIC ASSOCIATION FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS  SPECIFIC ASSOCIATION  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

######################  All Issuers Excludes Specific Association  ###########################
CARRIER ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  qTest:32675486  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  qTest:32675486  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}
    
######################  Specific Issuers All Location  ###########################
CARRIER SPECIFIC ISSUERS ALL LOCATIONS ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  qTest:32672780  Regression  CARRIER  SPECIFIC ISSUERS  ALL LOCATIONS  ALL PRODUCTS  EXTENDED TERMS FEE 
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS ALL LOCATIONS ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  ALL LOCATIONS  ALL PRODUCTS  IN NETWORK FEE 
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS ALL LOCATIONS ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  ALL LOCATIONS  ALL PRODUCTS  OUT OF NETWORK FEE 
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS ALL LOCATIONS ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  ALL LOCATIONS  ALL PRODUCTS  MISC ADDER FEE 
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS ALL LOCATIONS CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  ALL LOCATIONS  CASH ADVANCE ONLY  EXTENDED TERMS FEE 
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS ALL LOCATIONS CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  ALL LOCATIONS  CASH ADVANCE ONLY  IN NETWORK FEE 
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS ALL LOCATIONS CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  ALL LOCATIONS  CASH ADVANCE ONLY  OUT OF NETWORK FEE 
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS ALL LOCATIONS CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  ALL LOCATIONS  CASH ADVANCE ONLY  MISC ADDER FEE 
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS ALL LOCATIONS FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  ALL LOCATIONS  FUEL ONLY  EXTENDED TERMS FEE 
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS ALL LOCATIONS FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  ALL LOCATIONS  FUEL ONLY  IN NETWORK FEE 
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS ALL LOCATIONS FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  ALL LOCATIONS  FUEL ONLY  OUT OF NETWORK FEE 
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS ALL LOCATIONS FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  ALL LOCATIONS  FUEL ONLY  MISC ADDER FEE 
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS ALL LOCATIONS FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  ALL LOCATIONS  FUEL & CASH  EXTENDED TERMS FEE 
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS ALL LOCATIONS FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  ALL LOCATIONS  FUEL & CASH  IN NETWORK FEE 
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS ALL LOCATIONS FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  ALL LOCATIONS  FUEL & CASH  OUT OF NETWORK FEE 
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS ALL LOCATIONS FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  ALL LOCATIONS  FUEL & CASH  MISC ADDER FEE 
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

######################  Specific Issuers Specific Location  ###########################
CARRIER SPECIFIC ISSUERS SPECIFIC LOCATION ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC LOCATION  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC LOCATION ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC LOCATION  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC LOCATION ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC LOCATION  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC LOCATION ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC LOCATION  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC LOCATION CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC LOCATION  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC LOCATION CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  CARRIER  SPECIFIC ISSUERS  SPECIFIC LOCATION  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC LOCATION CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC LOCATION  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC LOCATION CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC LOCATION  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC LOCATION FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC LOCATION  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC LOCATION FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC LOCATION  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC LOCATION FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC LOCATION  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC LOCATION FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC LOCATION  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC LOCATION FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC LOCATION  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC LOCATION FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC LOCATION  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC LOCATION FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC LOCATION  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC LOCATION FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC LOCATION  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

######################  Specific Issuers Excludes Specific Location  ###########################
CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}
    
######################  Specific Issuers Specific Supplier  ###########################
CARRIER SPECIFIC ISSUERS SPECIFIC SUPPLIER ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC SUPPLIER ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC SUPPLIER ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC SUPPLIER ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC SUPPLIER CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC SUPPLIER CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC SUPPLIER CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC SUPPLIER CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC SUPPLIER FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC SUPPLIER FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC SUPPLIER FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  CARRIER  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC SUPPLIER FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC SUPPLIER FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC SUPPLIER FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC SUPPLIER FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC SUPPLIER FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

######################  Specific Issuers Excludes Specific Supplier  ###########################
CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}
    
######################  Specific Issuers Specific Chain  ###########################
CARRIER SPECIFIC ISSUERS SPECIFIC CHAIN ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC CHAIN  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC CHAIN ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC CHAIN  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC CHAIN ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC CHAIN  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC CHAIN ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC CHAIN  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC CHAIN CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC CHAIN  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC CHAIN CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC CHAIN  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC CHAIN CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC CHAIN  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC CHAIN CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC CHAIN  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC CHAIN FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC CHAIN  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC CHAIN FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC CHAIN  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC CHAIN FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC CHAIN  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC CHAIN FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC CHAIN  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC CHAIN FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC CHAIN  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC CHAIN FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC CHAIN  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC CHAIN FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC CHAIN  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC CHAIN FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  CARRIER  SPECIFIC ISSUERS  SPECIFIC CHAIN  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[1]}

######################  Specific Issuers Exclude Specific Chain  ###########################
CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

######################  Specific Issuers Specific Association  ###########################    
CARRIER SPECIFIC ISSUERS SPECIFIC ASSOCIATION ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  CARRIER  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC ASSOCIATION ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC ASSOCIATION ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC ASSOCIATION ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC ASSOCIATION FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC ASSOCIATION FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC ASSOCIATION FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC ASSOCIATION FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC ASSOCIATION FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC ASSOCIATION FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC ASSOCIATION FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS SPECIFIC ASSOCIATION FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

######################  Specific Issuers Excludes Specific Association  ###########################
CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}

CARRIER SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression  indepthadder  CARRIER  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  1  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[1]}
    






#############################  Owner ID as Contract ############################
######################  All Issuers ALL Location  ###########################
CONTRACT ALL ISSUERS ALL LOCATIONS ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  qTest:32672732  Regression  qTest:32676353  qTest:32676365  qTest:32676369  qTest:32676364  CONTRACT  ALL ISSUERS  ALL LOCATIONS  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS ALL LOCATIONS ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  ALL LOCATIONS  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS ALL LOCATIONS ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  ALL LOCATIONS  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS ALL LOCATIONS ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  ALL LOCATIONS  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS ALL LOCATIONS CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  ALL LOCATIONS  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS ALL LOCATIONS CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  ALL LOCATIONS  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS ALL LOCATIONS CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  ALL LOCATIONS  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS ALL LOCATIONS CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  ALL LOCATIONS  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS ALL LOCATIONS FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  ALL LOCATIONS  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS ALL LOCATIONS FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  ALL LOCATIONS  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS ALL LOCATIONS FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  ALL LOCATIONS  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS ALL LOCATIONS FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  ALL LOCATIONS  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS ALL LOCATIONS FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  ALL LOCATIONS  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS ALL LOCATIONS FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  ALL LOCATIONS  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS ALL LOCATIONS FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  ALL LOCATIONS  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS ALL LOCATIONS FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  ALL LOCATIONS  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

######################  All Issuers SPECIFIC Location  ###########################
CONTRACT ALL ISSUERS SPECIFIC LOCATION ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  qTest:32676356  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC LOCATION  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC LOCATION ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  qTest:32676357  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC LOCATION  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC LOCATION ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC LOCATION  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC LOCATION ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC LOCATION  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC LOCATION CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC LOCATION  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC LOCATION CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  qTest:32676357  qTest:32676366  qTest:32676370  CONTRACT  ALL ISSUERS  SPECIFIC LOCATION  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC LOCATION CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC LOCATION  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC LOCATION CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC LOCATION  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC LOCATION FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC LOCATION  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC LOCATION FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC LOCATION  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC LOCATION FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC LOCATION  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC LOCATION FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC LOCATION  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC LOCATION FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC LOCATION  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC LOCATION FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC LOCATION  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC LOCATION FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC LOCATION  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC LOCATION FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC LOCATION  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

######################  All Issuers Exclude Specific Location  ###########################
CONTRACT ALL ISSUERS EXCLUDES SPECIFIC LOCATION ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  qTest:32676358  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC LOCATION ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC LOCATION ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC LOCATION ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  qTest:32676358  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC LOCATION CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC LOCATION CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC LOCATION CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC LOCATION CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC LOCATION FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC LOCATION FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC LOCATION FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC LOCATION FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC LOCATION FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC LOCATION FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC LOCATION FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC LOCATION FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}
       
######################  All Issuers Specific Supplier  ###########################
CONTRACT ALL ISSUERS SPECIFIC SUPPLIER ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  qTest:32676359  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC SUPPLIER  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC SUPPLIER ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC SUPPLIER  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC SUPPLIER ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC SUPPLIER  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC SUPPLIER ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC SUPPLIER  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC SUPPLIER CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC SUPPLIER CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC SUPPLIER CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC SUPPLIER CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC SUPPLIER FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC SUPPLIER  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC SUPPLIER FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC SUPPLIER  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC SUPPLIER FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  qTest:32676359  qTest:32676367  qTest:32676371  CONTRACT  ALL ISSUERS  SPECIFIC SUPPLIER  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC SUPPLIER FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC SUPPLIER  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC SUPPLIER FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC SUPPLIER  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC SUPPLIER FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC SUPPLIER  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC SUPPLIER FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC SUPPLIER  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC SUPPLIER FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC SUPPLIER  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

######################  All Issuers excludes Specific Supplier  ###########################
CONTRACT ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  qTest:32676360  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  qTest:32676360  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

######################  All Issuers Specific Chain  ###########################
CONTRACT ALL ISSUERS SPECIFIC CHAIN ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  qTest:32676361  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC CHAIN  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC CHAIN ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC CHAIN  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC CHAIN ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC CHAIN  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC CHAIN ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC CHAIN  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC CHAIN CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC CHAIN  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC CHAIN CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC CHAIN  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC CHAIN CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC CHAIN  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC CHAIN CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC CHAIN  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC CHAIN FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC CHAIN  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC CHAIN FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC CHAIN  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC CHAIN FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC CHAIN  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC CHAIN FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC CHAIN  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC CHAIN FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC CHAIN  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC CHAIN FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC CHAIN  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC CHAIN FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC CHAIN  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC CHAIN FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  qTest:32676361  qTest:32676368  qTest:32676372  CONTRACT  ALL ISSUERS  SPECIFIC CHAIN  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[2]}

######################  All Issuers Exclude Specific Chain  ###########################
CONTRACT ALL ISSUERS EXCLUDES SPECIFIC CHAIN ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC CHAIN ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC CHAIN ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC CHAIN ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC CHAIN CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC CHAIN CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC CHAIN CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC CHAIN CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC CHAIN FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC CHAIN FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  qTest:32676362  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC CHAIN FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC CHAIN FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC CHAIN FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC CHAIN FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC CHAIN FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC CHAIN FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}
    
######################  All Issuers Specific Association  ###########################
CONTRACT ALL ISSUERS SPECIFIC ASSOCIATION ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  qTest:32676363  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC ASSOCIATION  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC ASSOCIATION ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  qTest:32676363  CONTRACT  ALL ISSUERS  SPECIFIC ASSOCIATION  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC ASSOCIATION ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC ASSOCIATION  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC ASSOCIATION ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC ASSOCIATION  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC ASSOCIATION FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC ASSOCIATION  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC ASSOCIATION FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC ASSOCIATION  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC ASSOCIATION FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC ASSOCIATION  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC ASSOCIATION FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC ASSOCIATION  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC ASSOCIATION FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC ASSOCIATION  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC ASSOCIATION FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC ASSOCIATION  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC ASSOCIATION FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC ASSOCIATION  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS SPECIFIC ASSOCIATION FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS  SPECIFIC ASSOCIATION  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

######################  All Issuers Excludes Specific Association  ###########################
CONTRACT ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  qTest:32676355  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}
    
######################  Specific Issuers All Location  ###########################
CONTRACT SPECIFIC ISSUERS ALL LOCATIONS ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  qTest:32676356  CONTRACT  SPECIFIC ISSUERS  ALL LOCATIONS  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS ALL LOCATIONS ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  ALL LOCATIONS  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS ALL LOCATIONS ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  ALL LOCATIONS  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS ALL LOCATIONS ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  ALL LOCATIONS  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS ALL LOCATIONS CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  ALL LOCATIONS  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS ALL LOCATIONS CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  ALL LOCATIONS  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS ALL LOCATIONS CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  ALL LOCATIONS  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS ALL LOCATIONS CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  ALL LOCATIONS  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS ALL LOCATIONS FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  ALL LOCATIONS  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS ALL LOCATIONS FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  ALL LOCATIONS  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS ALL LOCATIONS FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  ALL LOCATIONS  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS ALL LOCATIONS FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  ALL LOCATIONS  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS ALL LOCATIONS FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  ALL LOCATIONS  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS ALL LOCATIONS FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  ALL LOCATIONS  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS ALL LOCATIONS FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  ALL LOCATIONS  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS ALL LOCATIONS FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  ALL LOCATIONS  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

######################  Specific Issuers Specific Location  ###########################
CONTRACT SPECIFIC ISSUERS SPECIFIC LOCATION ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC LOCATION  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC LOCATION ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC LOCATION  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC LOCATION ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC LOCATION  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC LOCATION ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC LOCATION  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC LOCATION CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC LOCATION  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC LOCATION CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  CONTRACT  SPECIFIC ISSUERS  SPECIFIC LOCATION  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC LOCATION CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC LOCATION  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC LOCATION CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC LOCATION  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC LOCATION FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC LOCATION  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC LOCATION FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC LOCATION  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC LOCATION FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC LOCATION  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC LOCATION FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC LOCATION  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC LOCATION FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC LOCATION  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC LOCATION FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC LOCATION  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC LOCATION FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC LOCATION  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC LOCATION FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC LOCATION  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

######################  Specific Issuers Excludes Specific Location  ###########################
CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  qTest:32676355  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}
    
######################  Specific Issuers Specific Supplier  ###########################
CONTRACT SPECIFIC ISSUERS SPECIFIC SUPPLIER ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC SUPPLIER ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC SUPPLIER ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC SUPPLIER ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC SUPPLIER CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC SUPPLIER CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC SUPPLIER CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC SUPPLIER CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC SUPPLIER FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC SUPPLIER FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC SUPPLIER FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  CONTRACT  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC SUPPLIER FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC SUPPLIER FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC SUPPLIER FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC SUPPLIER FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC SUPPLIER FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

######################  Specific Issuers Excludes Specific Supplier  ###########################
CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}
    
######################  Specific Issuers Specific Chain  ###########################
CONTRACT SPECIFIC ISSUERS SPECIFIC CHAIN ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC CHAIN  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC CHAIN ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC CHAIN  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC CHAIN ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC CHAIN  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC CHAIN ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC CHAIN  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC CHAIN CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC CHAIN  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC CHAIN CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC CHAIN  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC CHAIN CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC CHAIN  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC CHAIN CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC CHAIN  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC CHAIN FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC CHAIN  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC CHAIN FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC CHAIN  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC CHAIN FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC CHAIN  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC CHAIN FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC CHAIN  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC CHAIN FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC CHAIN  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC CHAIN FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC CHAIN  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC CHAIN FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC CHAIN  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC CHAIN FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  CONTRACT  SPECIFIC ISSUERS  SPECIFIC CHAIN  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[2]}

######################  Specific Issuers Exclude Specific Chain  ###########################
CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

######################  Specific Issuers Specific Association  ###########################    
CONTRACT SPECIFIC ISSUERS SPECIFIC ASSOCIATION ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  CONTRACT  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC ASSOCIATION ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC ASSOCIATION ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC ASSOCIATION ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC ASSOCIATION FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC ASSOCIATION FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC ASSOCIATION FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC ASSOCIATION FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC ASSOCIATION FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC ASSOCIATION FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC ASSOCIATION FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS SPECIFIC ASSOCIATION FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

######################  Specific Issuers Excludes Specific Association  ###########################
CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}

CONTRACT SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303378  Regression  indepthadder  CONTRACT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  2  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[2]}





#############################  Owner ID as Parent  ############################
##########################  All Issuer All Location  ##########################
PARENT ALL ISSUERS ALL LOCATIONS ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  qTest:32672749  Regression  qTest:32699979  qTest:32699989  qTest:32699990  qTest:32699994  PARENT  ALL ISSUERS  ALL LOCATIONS  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS ALL LOCATIONS ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  ALL LOCATIONS  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS ALL LOCATIONS ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  ALL LOCATIONS  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS ALL LOCATIONS ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  ALL LOCATIONS  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS ALL LOCATIONS CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  ALL LOCATIONS  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS ALL LOCATIONS CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  ALL LOCATIONS  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS ALL LOCATIONS CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  ALL LOCATIONS  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS ALL LOCATIONS CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  ALL LOCATIONS  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS ALL LOCATIONS FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  ALL LOCATIONS  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS ALL LOCATIONS FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  ALL LOCATIONS  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS ALL LOCATIONS FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  ALL LOCATIONS  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS ALL LOCATIONS FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  ALL LOCATIONS  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS ALL LOCATIONS FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  ALL LOCATIONS  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS ALL LOCATIONS FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  ALL LOCATIONS  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS ALL LOCATIONS FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  ALL LOCATIONS  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS ALL LOCATIONS FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  ALL LOCATIONS  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

######################  All Issuers SPECIFIC Location  ###########################
PARENT ALL ISSUERS SPECIFIC LOCATION ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC LOCATION  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC LOCATION ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC LOCATION  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC LOCATION ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC LOCATION  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC LOCATION ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC LOCATION  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC LOCATION CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC LOCATION  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC LOCATION CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  qTest:32699981  qTest:32699991  qTest:32699995  PARENT  ALL ISSUERS  SPECIFIC LOCATION  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC LOCATION CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC LOCATION  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC LOCATION CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC LOCATION  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC LOCATION FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC LOCATION  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC LOCATION FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC LOCATION  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC LOCATION FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC LOCATION  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC LOCATION FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC LOCATION  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC LOCATION FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC LOCATION  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC LOCATION FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC LOCATION  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC LOCATION FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC LOCATION  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC LOCATION FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC LOCATION  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

######################  All Issuers Exclude Specific Location  ###########################
PARENT ALL ISSUERS EXCLUDES SPECIFIC LOCATION ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC LOCATION ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC LOCATION ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC LOCATION ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  qTest:32699982  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC LOCATION CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC LOCATION CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC LOCATION CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC LOCATION CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC LOCATION FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC LOCATION FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC LOCATION FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC LOCATION FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC LOCATION FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC LOCATION FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC LOCATION FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC LOCATION FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}
       
######################  All Issuers Specific Supplier  ###########################
PARENT ALL ISSUERS SPECIFIC SUPPLIER ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC SUPPLIER  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC SUPPLIER ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC SUPPLIER  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC SUPPLIER ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC SUPPLIER  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC SUPPLIER ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC SUPPLIER  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC SUPPLIER CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC SUPPLIER CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC SUPPLIER CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC SUPPLIER CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC SUPPLIER FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC SUPPLIER  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC SUPPLIER FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC SUPPLIER  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC SUPPLIER FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  qTest:32699983  qTest:32699992  qTest:32699996  PARENT  ALL ISSUERS  SPECIFIC SUPPLIER  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC SUPPLIER FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC SUPPLIER  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC SUPPLIER FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC SUPPLIER  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC SUPPLIER FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC SUPPLIER  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC SUPPLIER FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC SUPPLIER  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC SUPPLIER FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC SUPPLIER  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

######################  All Issuers excludes Specific Supplier  ###########################
PARENT ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  qTest:32699984  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

######################  All Issuers Specific Chain  ###########################
PARENT ALL ISSUERS SPECIFIC CHAIN ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC CHAIN  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC CHAIN ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC CHAIN  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC CHAIN ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC CHAIN  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC CHAIN ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC CHAIN  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC CHAIN CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC CHAIN  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC CHAIN CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC CHAIN  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC CHAIN CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC CHAIN  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC CHAIN CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC CHAIN  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC CHAIN FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC CHAIN  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC CHAIN FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC CHAIN  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC CHAIN FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC CHAIN  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC CHAIN FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC CHAIN  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC CHAIN FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC CHAIN  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC CHAIN FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC CHAIN  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC CHAIN FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC CHAIN  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC CHAIN FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  qTest:32699985  qTest:32699993  qTest:32699997  PARENT  ALL ISSUERS  SPECIFIC CHAIN  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[3]}

######################  All Issuers Exclude Specific Chain  ###########################
PARENT ALL ISSUERS EXCLUDES SPECIFIC CHAIN ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC CHAIN ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC CHAIN ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC CHAIN ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC CHAIN CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC CHAIN CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC CHAIN CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC CHAIN CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC CHAIN FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC CHAIN FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  qTest:32699986  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC CHAIN FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC CHAIN FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC CHAIN FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC CHAIN FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC CHAIN FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC CHAIN FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}
    
######################  All Issuers Specific Association  ###########################
PARENT ALL ISSUERS SPECIFIC ASSOCIATION ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC ASSOCIATION  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC ASSOCIATION ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  qTest:32699987  PARENT  ALL ISSUERS  SPECIFIC ASSOCIATION  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC ASSOCIATION ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC ASSOCIATION  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC ASSOCIATION ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC ASSOCIATION  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC ASSOCIATION FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC ASSOCIATION  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC ASSOCIATION FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC ASSOCIATION  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC ASSOCIATION FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC ASSOCIATION  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC ASSOCIATION FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC ASSOCIATION  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC ASSOCIATION FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC ASSOCIATION  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC ASSOCIATION FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC ASSOCIATION  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC ASSOCIATION FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC ASSOCIATION  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS SPECIFIC ASSOCIATION FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS  SPECIFIC ASSOCIATION  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

######################  All Issuers Excludes Specific Association  ###########################
PARENT ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  qTest:32699988  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT ALL ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  ALL ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  1  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}
    
######################  Specific Issuers All Location  ###########################
PARENT SPECIFIC ISSUERS ALL LOCATIONS ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  PARENT  SPECIFIC ISSUERS  ALL LOCATIONS  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS ALL LOCATIONS ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  ALL LOCATIONS  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS ALL LOCATIONS ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  ALL LOCATIONS  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS ALL LOCATIONS ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  ALL LOCATIONS  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS ALL LOCATIONS CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  ALL LOCATIONS  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS ALL LOCATIONS CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  ALL LOCATIONS  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS ALL LOCATIONS CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  ALL LOCATIONS  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS ALL LOCATIONS CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  ALL LOCATIONS  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS ALL LOCATIONS FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  ALL LOCATIONS  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS ALL LOCATIONS FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  ALL LOCATIONS  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS ALL LOCATIONS FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  ALL LOCATIONS  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS ALL LOCATIONS FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  ALL LOCATIONS  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS ALL LOCATIONS FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  ALL LOCATIONS  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS ALL LOCATIONS FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  ALL LOCATIONS  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS ALL LOCATIONS FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  ALL LOCATIONS  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS ALL LOCATIONS FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  ALL LOCATIONS  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  1  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

######################  Specific Issuers Specific Location  ###########################
PARENT SPECIFIC ISSUERS SPECIFIC LOCATION ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC LOCATION  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC LOCATION ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC LOCATION  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC LOCATION ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC LOCATION  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC LOCATION ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC LOCATION  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC LOCATION CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC LOCATION  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC LOCATION CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  PARENT  SPECIFIC ISSUERS  SPECIFIC LOCATION  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC LOCATION CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC LOCATION  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC LOCATION CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC LOCATION  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC LOCATION FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC LOCATION  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC LOCATION FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC LOCATION  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC LOCATION FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC LOCATION  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC LOCATION FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC LOCATION  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC LOCATION FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC LOCATION  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC LOCATION FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC LOCATION  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC LOCATION FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC LOCATION  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC LOCATION FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC LOCATION  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

######################  Specific Issuers Excludes Specific Location  ###########################
PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC LOCATION FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC LOCATION  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  2  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}
    
######################  Specific Issuers Specific Supplier  ###########################
PARENT SPECIFIC ISSUERS SPECIFIC SUPPLIER ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC SUPPLIER ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC SUPPLIER ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC SUPPLIER ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC SUPPLIER CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC SUPPLIER CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC SUPPLIER CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC SUPPLIER CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC SUPPLIER FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC SUPPLIER FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC SUPPLIER FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  PARENT  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC SUPPLIER FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC SUPPLIER FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC SUPPLIER FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC SUPPLIER FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC SUPPLIER FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC SUPPLIER  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

######################  Specific Issuers Excludes Specific Supplier  ###########################
PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC SUPPLIER FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC SUPPLIER  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  3  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}
    
######################  Specific Issuers Specific Chain  ###########################
PARENT SPECIFIC ISSUERS SPECIFIC CHAIN ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC CHAIN  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC CHAIN ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC CHAIN  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC CHAIN ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC CHAIN  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC CHAIN ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC CHAIN  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC CHAIN CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC CHAIN  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC CHAIN CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC CHAIN  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC CHAIN CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC CHAIN  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC CHAIN CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC CHAIN  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC CHAIN FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC CHAIN  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC CHAIN FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC CHAIN  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC CHAIN FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC CHAIN  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC CHAIN FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC CHAIN  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC CHAIN FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC CHAIN  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC CHAIN FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC CHAIN  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC CHAIN FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC CHAIN  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC CHAIN FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  PARENT  SPECIFIC ISSUERS  SPECIFIC CHAIN  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[3]}

######################  Specific Issuers Exclude Specific Chain  ###########################
PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC CHAIN FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC CHAIN  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  4  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

######################  Specific Issuers Specific Association  ###########################    
PARENT SPECIFIC ISSUERS SPECIFIC ASSOCIATION ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  PARENT  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC ASSOCIATION ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC ASSOCIATION ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC ASSOCIATION ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC ASSOCIATION FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC ASSOCIATION FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC ASSOCIATION FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC ASSOCIATION FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC ASSOCIATION FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC ASSOCIATION FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  FUEL & CASH  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC ASSOCIATION FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS SPECIFIC ASSOCIATION FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS  SPECIFIC ASSOCIATION  FUEL & CASH  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  0  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

######################  Specific Issuers Excludes Specific Association  ###########################
PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION ALL PRODUCTS for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  ALL PRODUCTS  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION ALL PRODUCTS for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  ALL PRODUCTS  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION ALL PRODUCTS for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  ALL PRODUCTS  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION ALL PRODUCTS for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  ALL PRODUCTS  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  1  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION CASH ADVANCE ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  CASH ADVANCE ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  2  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL ONLY for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL ONLY  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL ONLY for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL ONLY  IN NETWORK FEE  
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL ONLY for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL ONLY  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL ONLY for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL ONLY  MISC ADDER FEE  
    set test variable  ${FEETYPE}  4
    set test variable  ${productTypeId}  3  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL & CASH for the EXTENDED TERMS FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL & CASH  EXTENDED TERMS FEE  
    set test variable  ${FEETYPE}  1
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    Add Fee via Account Manager  ${owner[${ownerTypeId}]}
    Verify Fee Displays  ${owner[${ownerTypeId}]}
    Verify in Database  ${owner[${ownerTypeId}]}
    Update eff and exp  ${owner[${ownerTypeId}]}  ${dbyesterday}  ${dbtomorrow}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}    
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL & CASH for the IN NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL & CASH  IN NETWORK FEE
    set test variable  ${FEETYPE}  2
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL & CASH for the OUT OF NETWORK FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL & CASH  OUT OF NETWORK FEE  
    set test variable  ${FEETYPE}  3
    set test variable  ${productTypeId}  4  
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}   
    [Teardown]  Delete fee  ${owner[3]}

PARENT SPECIFIC ISSUERS EXCLUDES SPECIFIC ASSOCIATION FUEL & CASH for the MISC ADDER FEE type
    [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303379  Regression  indepthadder test  PARENT  SPECIFIC ISSUERS EXCLUDES  SPECIFIC ASSOCIATION  FUEL & CASH  MISC ADDER FEE
    set test variable   ${FEETYPE}  4
    set test variable  ${productTypeId}  4
    set test variable  ${matches}  2  
    set test variable  ${siteTypeId}  5  
    set test variable  ${issuerTypeId}  2  
    set test variable  ${ownerTypeId}  3  
    DB Add Fee  ${owner[${ownerTypeId}]}
    ${string}=  Create AC String by product 
    run transaction  ${card[${ownerTypeId}]}  ${string}
    [Teardown]  Delete fee  ${owner[3]}

########################### Other Tests  ########################################
Expire Test
  [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303380  Regression
  set test variable   ${FEETYPE}  1
  set test variable  ${productTypeId}  1
  set test variable  ${matches}  0
  set test variable  ${siteTypeId}  1
  set test variable  ${issuerTypeId}  1
  set test variable  ${ownerTypeId}  1
  ${db2daysago}=  getDateTimeNow  %Y-%m-%d 00:00  days=-2
  Add Fee via Account Manager  ${owner[${ownerTypeId}]}
  Update eff and exp  ${owner[${ownerTypeId}]}  ${db2daysago}  ${dbyesterday}
  ${string}=  Create AC String by product
  set test variable  ${matches}  2
  Run transaction  ${card[${ownerTypeId}]}  ${string}
  [Teardown]  Delete fee  ${owner[1]}

Effective Test
  [Tags]  JIRA:FLT-221  JIRA:FLT-544  JIRA:BOT-300  JIRA:BOT-1852  qTest:32303377  Regression
  set test variable   ${FEETYPE}  1
  set test variable  ${productTypeId}  1
  set test variable  ${matches}  0
  set test variable  ${siteTypeId}  1
  set test variable  ${issuerTypeId}  1
  set test variable  ${ownerTypeId}  1
  Add Fee via Account Manager  ${owner[1]}
  ${string}=  Create AC String by product
  set test variable  ${matches}  2
  Run transaction  ${card[${ownerTypeId}]}  ${string}
  [Teardown]  Delete fee  ${owner[1]}

*** Keywords ***
Create AC String by product
   ${string} =  run keyword if  ${productTypeId}==1  Create AC String  TCH  ${location}  ${card[${ownerTypeId}]}  ULSD=5.00  SCLE=1.50
   ...   ELSE IF  ${productTypeId}==2  Create AC String  TCH  ${location}  ${card[${ownerTypeId}]}  CADV=5.00
   ...   ELSE IF  ${productTypeId}==3  Create AC String  TCH  ${location}  ${card[${ownerTypeId}]}  ULSD=5.00
   ...   ELSE IF  ${productTypeId}==4  Create AC String  TCH  ${location}  ${card[${ownerTypeId}]}  ULSD=5.00  CADV=5.00
   [Return]  ${string}

Add Fee via Account Manager
    [Arguments]  ${owner}
    input text  ownerId  ${owner}  #adding owner to the search so it searches quick
    click on  xpath=//*[@name="ownerTypeId"]/option[@value="${ownerTypeId}"]  timeout=20  #select Owner type
    click on  xpath=//span[contains(text(),'ADD')]
    click element  xpath=//*[@name='carrierAdderFees.ownerTypeId']/option[@value='${ownerTypeId}']  #select Owner type Carrier,
    input text  //*[@name="carrierAdderFees.ownerId"]  ${owner}
    click element  xpath=//*[@name='carrierAdderFees.issuerTypeId']/option[@value='${issuerTypeId}']  #selecting all issers
    run keyword if  ${issuerTypeId}==2 and ${ownerTypeId} < 3  click element  xpath=//*[@name='carrierAdderFees.issuerId']/option[@value='194134']
    run keyword if  ${issuerTypeId}==2 and ${ownerTypeId} == 3  click element  xpath=//*[@name='carrierAdderFees.issuerId']/option[@value='189984']
    click element  xpath=//*[@name='carrierAdderFees.siteTypeId']/option[@value='${siteTypeId}']  #selecting all locations
    # below assigns the value for the location it should enter either location id, supplier id, chain id etc.
    run keyword if  ${siteTypeId}==2  input text  //*[@name="carrierAdderFees.siteId"]  502434
    ...   ELSE IF  ${siteTypeId}==3  input text  //*[@name="carrierAdderFees.siteId"]  104604
    ...   ELSE IF  ${siteTypeId}==4  click element  xpath=//*[@name='carrierAdderFees.chainId']/option[@value='13']
    ...   ELSE IF  ${siteTypeId}==5  click element  xpath=//*[@name='carrierAdderFees.assocId']/option[@value='4']
    run keyword if   ${matches}>0  click element  xpath=//*[@name='carrierAdderFees.filterTypeId']/option[@value='${matches}']
    input text  //*[@name="carrierAdderFees.feeAdder"]  ${AdderFee}
    click element  xpath=//*[@name='carrierAdderFees.productTypeId']/option[@value='${productTypeId}']  #selecting all products
    click element  xpath=//*[@name='carrierAdderFees.feeTypeId']/option[@value='${feeType}']  #selecting Extended Terms Fee
    input text  //*[@name="carrierAdderFees.effDt"]  ${webtomorrow}
    input text  //*[@name="carrierAdderFees.expDt"]  ${webnextday}
    click on  xpath=//*[@id="submit"]

DB Add Fee
    [Arguments]  ${owner}
    ${siteId}  set variable if  ${siteTypeId}==1  NULL
    ...   ${siteTypeId}==2  502434
    ...   ${siteTypeId}==3  104604
    ...   ${siteTypeId}==4  13
    ...   ${siteTypeId}==5  4
    ${issuerId}  set variable if  ${issuerTypeId}==1  NULL
    ...   ${issuerTypeId}==2 and ${ownerTypeId} < 3  194134
    ...   ${issuerTypeId}==2 and ${ownerTypeId} == 3  189984
    ${matches}  set variable if  ${matches}==0  1
    ...   ${matches}>0  ${matches}
    Execute SQL String  dml=INSERT INTO carrier_fee_adder (owner_type_id,owner_id,issuer_type_id,issuer_id,site_type_id,site_id,site_filter_type_id,product_type_id,fee_type_id,fee_adder,eff_date,exp_date) VALUES(${ownerTypeId},${owner},${issuerTypeId},${issuerId},${siteTypeId},${siteId},${matches},${productTypeId},${feeType},${AdderFee},'${dbyesterday}','${dbtomorrow}');

Clean up
    ${end}=  getdatetimenow  %H:%M
    tch logging  Start ${start} End ${end}  DEBUG
    FOR  ${INDEX}  IN RANGE  1  4
        Delete fee  ${owner[${INDEX}]}
        run command  echo 'LOAD FROM '${owner[${INDEX}]}_carrierfeeadder.unl' insert into carrier_fee_adder;' > ${owner[${INDEX}]}load.sql
        run command  dbaccess $TCH_DB < ${owner[${INDEX}]}load.sql
    END
    close browser

Delete fee
    [Arguments]  ${owner}
    Execute SQL String  dml=DELETE from carrier_fee_adder where owner_id = ${owner}

time to setup
    ${today}=    getDateTimeNow  %Y-%m-%d
    ${webtomorrow}=  getDateTimeNow  %m/%d/%Y  days=1
    ${dbtomorrow}=  getDateTimeNow  %Y-%m-%d 00:00  days=1
    ${webnextday}=  getDateTimeNow  %m/%d/%Y  days=2
    ${dbyesterday}=  getDateTimeNow  %Y-%m-%d 00:00  days=-1
    ${start}=  getDateTimeNow  %H:%M

    set global variable  ${today}
    set global variable  ${webtomorrow}
    set global variable  ${dbtomorrow}
    set global variable  ${webnextday}
    set global variable  ${dbyesterday}
    set global variable  ${start}
    set global variable  ${emanager}
    Open Account Manager
    click on  text=Adder Fees

    ${myPass}=  get carrier password  ${owner[1]}
    ${otherPass}=  get carrier password  700068

    Set up Cards  ${owner[1]}  ${myPass}  ${card[1]}  ULSD  CADV  SCLE
    Set up Cards  ${owner[1]}  ${myPass}  ${card[2]}  ULSD  CADV  SCLE
    Set up Cards  700068  ${otherPass}  ${card[3]}  ULSD  CADV  SCLE
    Get Into DB  tch
    FOR  ${INDEX}  IN RANGE  1  4
        Delete fee  ${owner[${INDEX}]}
        ensure no primary parent  ${owner[${INDEX}]}
        run keyword if  ${INDEX}!=2  Update Limit  ${owner[${INDEX}]}
        run keyword if  ${INDEX}==2  Update Contract Limits  ${owner[${INDEX}]}
    END
    FOR  ${INDEX}  IN RANGE  1  4
        ensure parent setup  ${card[${INDEX}]}
    END

Set up Cards
    [Arguments]  ${carrier}  ${pass}  ${card}  @{PRODS}

    Get Into DB  tch
    @{products}=  create list
    log into card management web services  ${carrier}  ${pass}
    FOR  ${PROD}  IN  @{PRODS}
        append to list  ${products}  1  9999  ${PROD}  0
    END
    setCardLimits  ${card}  ${True}  ${products}
    setCardHeader  ${card}  status=ACTIVE
    logout
    #setting contract limit for contract 269312 test case contract and carrier
    Execute SQL String  dml=UPDATE contract SET daily_bal = 0, credit_bal = 0, credit_limit = 99999.00, daily_limit = 99999.00 WHERE contract_id = ${owner[2]}
    #setting contract for parent test case
    Execute SQL String  dml=UPDATE contract SET daily_bal = 0, credit_bal = 0, credit_limit = 99999.00, daily_limit = 99999.00 WHERE contract_id = 700068

Run Transaction
    [Arguments]  ${card}  ${string}
    Get Into DB  tch
    ${myLog}=  create log file  CarrierAdder
    ${log}=  Run rossAuth  ${string}  ${myLog}
    ${transid} =  Get Transaction ID From Log File  ${log}
    ${matchesTrue} =  evaluate  ${matches}==2
    run keyword if  ${matchesTrue}  Trans Fee Failed  ${trans_id}  ${feeType}  ELSE  Trans Fee Success  ${trans_id}  ${feeType}  ${adderfee}

Trans Fee Success
    [Arguments]  ${trans_id}  ${feeType}  ${adderfee}
    Get Into DB  tch  ${ENVIRONMENT}
    ${feename} =  query and strip  select trans_meta_type_id from carrier_fee_adder_fee_types where fee_type_id = ${feeType}
    ${fee} =  query and strip  select trans_meta_data from trans_meta where trans_id = ${trans_id} and trans_meta_type_id = "${feename}"
    should be equal as numbers  ${fee}  ${adderfee}

Trans Fee Failed
    [Arguments]  ${trans_id}  ${feeType}
    Get Into DB  tch  ${ENVIRONMENT}
    ${feename} =  query and strip  select trans_meta_type_id from carrier_fee_adder_fee_types where fee_type_id = ${feeType}
    row count is 0  select trans_meta_data from trans_meta where trans_id = ${trans_id} and trans_meta_type_id = "${feename}"

Update eff and exp
    [Arguments]  ${owner}  ${eff_date}  ${exp_date}
    Execute SQL String  dml=UPDATE carrier_fee_adder set eff_date = '${eff_date}', exp_date = '${exp_date}' where eff_date = '${dbtomorrow}' and owner_id=${owner}

Verify Fee Displays
      [Arguments]  ${owner}
      sleep  1
      wait until loading spinners are gone
      click on  xpath=//*[@name="ownerTypeId"]/option[@value="${ownerTypeId}"]  timeout=20  #select Owner type
      check element exists  xpath=//*[@name="ownerId"]  timeout=20
      input text  ownerId  ${owner}
      double click on  xpath=(//button[@class="button searchSubmit"])[2]
      wait until loading spinners are gone
      Wait Until Page Contains Element  xpath=//td[contains(text(),'${owner}')]  timeout=20
      Page Should Contain Element  xpath=//td[contains(text(),'${owner}')]

Verify in Database
    [Arguments]  ${carrier}
    Get Into DB  tch  ${ENVIRONMENT}
    ${results} =  query and strip to dictionary  select * from carrier_fee_adder where owner_id=${carrier}
    should be equal as numbers  ${results["site_type_id"]}  ${siteTypeId}
    should be equal as numbers  ${results["owner_id"]}  ${carrier}
    should be equal as numbers  ${results["owner_type_id"]}  ${ownerTypeId}
    should be equal as numbers  ${results["issuer_type_id"]}  ${issuerTypeId}
    should be equal as numbers  ${results["product_type_id"]}  ${productTypeId}
    should be equal as numbers  ${results["fee_adder"]}  ${AdderFee}
    should be equal as numbers  ${results["fee_type_id"]}  ${feeType}
    ${results["eff_date"]}=  convert date  ${results["eff_date"]}  result_format=%m/%d/%Y
    should be equal  ${results["eff_date"]}  ${webtomorrow}
    ${results["exp_date"]}=  convert date  ${results["exp_date"]}  result_format=%m/%d/%Y
    should be equal  ${results["exp_date"]}  ${webnextday}

Ensure no primary parent
    [Arguments]  ${carrier_id}
    Execute SQL String  dml=DELETE from primary_parent_xref where carrier_id = ${carrier_id}

ensure parent setup
    [Arguments]  ${cardNum}

    ${carrier}  ${carPassword}=  get carrier info from card  ${cardNum}

    ${index}=  get index from list  ${card}  ${cardNum}

    #clear all primary parents (ensures no extra adder fees will come through)
    ensure no primary parent  ${carrier}

    #set up primary parent like we expect
    ${insertSql}=  assign string  insert into primary_parent_xref (carrier_id,parent_id,priority) values(${carrier},@{owner}[${index}],1)
    execute sql string  ${insertSql}




