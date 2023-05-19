*** Settings ***
Documentation
...  | Create a new application and test the process of completing a new contract through Application Manager.
...  | The following keywords are defined as follows:
...
...  |  INITIAL SETUP PHASE     | INITIALIZES APPLICATION |
...  |   ADD NEW CONTRACT       | CREATES A NEW CONTRACT  |
...  |  COMPLETE SALES STAGE    | TAKES CONTACT FROM SALES TO CREDIT |
...  |  COMPLETE CREDIT STAGE   | TAKES CONTACT FROM CREDIT TO PROCESSED |
...
...  | See PortalKeywords for more information on how the keywords function.



Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ui.web.PySelenium
Resource  ../Keywords/PortalKeywords.robot
Resource  ../Variables/validUser.robot
Resource  ../Keywords/CreateApplicationKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot

Suite Teardown  close all browsers

Force Tags  Application Manager

*** Test Cases ***
# +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+
# |                                      CREATING AND DELETING NEW APPLICATIONS                                              |
# +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+

#########################################################################################################################
## I KNOW THIS LOOKS COMPLICATED, SO PLEASE TAKE A MINUTE TO LOOK OVER THE DESCRIPTION OF HOW TO CREATE A NEW TEST IN  ##
## CREATING AN APPLICATION. ONCE YOU UNDERSTAND IT THEN IT IS QUICK AND SIMPLE TO IMPLEMENT.                           ##
##                                                                                              -TYLER                 ##
#########################################################################################################################


#+------------------------------------------------------------------------------------------------------------------+
#|                                                                                                                  |
#|     COMPLETE A CONTRACT MANUALLY BEFORE AUTOMATING SO YOU KNOW WHAT VALUES YOU NEED FOR THE ARGUMENTS BELOW      |
#|                                                                                                                  |
#+-----------------------+------------------------------------------------------------------------------------------+
#|       KEYWORD         |                                     PARAMETERS                                           |
#+-----------------------+------------------------------------------------------------------------------------------+
#|Open Application Manager       |  None                                                                                    |
#|Initial Setup Phase    |  ${accounting_org}  ${sales_territory}                                                   |
#|Add New Contract       |  ${card_type}                                                                            |
#|Complete Sales Stage   |  ${fees_tab}  ${revenue_tab}  ${revenue_tab_location}  ${confirm_no_attachments}         |
#|Complete Credit Stage  |  ${need_MSA}  ${creditSetup_tab_location}  ${issuer_id}  ${card_style}  ${needEmail} |
#|Delete Robot App       |  None                                                                                    |
#+-----------------------+------------------------------------------------------------------------------------------+

#+--------------------------+------------------------------------------------------------------------+
#|   KEYWORD / parameter    |                             DESCRIPTION                                |
#+--------------------------+------------------------------------------------------------------------+
#|  INITIAL SETUP PHASE     |                      CREATES A NEW APPLICATION                         |
#+  --------------------    +        ---------------------------------------------------             +
#|    accounting_org        |         Company Info & Sales Tab - Account Setup box                   |
#|    sales_territory       |         Company Info & Sales Tab - Sales box                           |
#+--------------------------+------------------------------------------------------------------------+
#|   ADD NEW CONTRACT       |                        CREATES A NEW CONTRACT                          |
#+  -------------------     +        ---------------------------------------------------             +
#|      card_type           |         Contract Detail & Sales Tab - Contract Detail box              |
#|--------------------------+------------------------------------------------------------------------+
#|  COMPLETE SALES STAGE    |                  TAKES CONTACT FROM SALES TO CREDIT                    |
#+ ----------------------   +        ---------------------------------------------------             +
#|      fees_tab            |        If the Fees tab exists, then ${True}, else ${False}             |
#|     revenue_tab          |    If the Projected Revenue tab exists, then ${True}, else ${False}    |
#|  revenue_tab_location    |  Which tab from the left, starting at 1, is the Projected Revenue tab? |
#| confirm_no_attachments   |   If you're asked if you want attachments the ${True}, else ${False}   |
#|--------------------------+------------------------------------------------------------------------+
#|  COMPLETE CREDIT STAGE   |                  TAKES CONTACT FROM SALES TO CREDIT                    |
#+ -----------------------  +        ---------------------------------------------------             +
#|       need_MSA           | If an error occurs if MSA isn't completed then ${True}, else ${False}  |
#| creditSetup_tab_location |       Which tab from the left, starting at 1, is the Credit tab?       |
#|      issuer_id           |               Credit Setup Tab - Credit Setup box                      |
#|      card_style          |               Credit Setup Tab - Credit Setup box                      |
#+--------------------------+------------------------------------------------------------------------+

#+---------------------------------------------------------------------------------------------------------------------------------+
#|                                                          EXAMPLE                                                                |
#+---------------------------------------------------------------------------------------------------------------------------------+
#| Create A Contract                                                                                                               |
#|     [Tags]  New Application                                                                                                     |
#|     Open Application Manager                                                                                                            |
#|     Inital Setup Phase  <organizatin id (int)>  <sales territory (string)>                                                      |
#|     Add New Contract  <card type (int)>                                                                                         |
#|     Complete Sales Stage  <fee tab (bool)>  <revenue tab (bool)>  <revenue tab location (int)>  <confirm no attachments (bool)> |
#|     Complete Credit Stage  <need MSA (bool)>  <credit setup tab location (int)>  <issuer id (int)>  <card style (int)>          |
#|     Complete Processing Stage                                                                                                   |
#|     close browser                                                                                                               |
#|     Delete Robot App                                                                                                            |
#+---------------------------------------------------------------------------------------------------------------------------------+

Create TCH Fleet Fuel Contract
    [Tags]  New Application
    Open Application Manager
    Inital Setup Phase  81  E1
    Add New Contract  4
    Complete Sales Stage
    Complete Credit Stage  105757  1
    Complete Processing Stage
    close browser

    [Teardown]  Delete Robot App
Create Shell Navigator MasterCard Contract
    [Tags]  New Application
    Open Application Manager
    Inital Setup Phase  102  FE
    Add New Contract  28
    Complete Sales Stage
    Complete Credit Stage  161738  55
    Complete Processing Stage
    close browser

    [Teardown]  Delete Robot App

#Create TCH Fleet MasterCard Contract
#    [Tags]  New Application
#    Open Application Manager
#    Inital Setup Phase  81  E1
#    Add New Contract  5
#    Complete Sales Stage
#    Complete Credit Stage  118897  62
#    Complete Processing Stage
#    close browser
#
#    [Teardown]  Delete Robot App
#Create TCH Smart Pay Contract
#    [Tags]  New Application
#    Open Application Manager
#    Inital Setup Phase  81  E1
#    Add New Contract  2
#    Complete Sales Stage
#    Complete Credit Stage  140186  25
#    Complete Processing Stage
#    close browser
#
#    [Teardown]  Delete Robot App
#Create Shell Triton Contract
#    [Tags]  New Application
#    Open Application Manager
#    Inital Setup Phase  102  FE
#    Add New Contract  13
#    Complete Sales Stage
#    Complete Credit Stage  131824  15
#    Complete Processing Stage
#    close browser
#
#    [Teardown]  Delete Robot App
#Create SFJ Express Contract
#    [Tags]  New Application
#    Open Application Manager
#    Inital Setup Phase  101  E1
#    Add New Contract  14
#    Complete Sales Stage
#    Complete Credit Stage  133769  23
#    Complete Processing Stage
#    close browser
#
#    [Teardown]  Delete Robot App
#Create Imperial Contract
#    [Tags]  New Application
#    Open Application Manager
#    Inital Setup Phase  125  BD
#    Add New Contract  4
#    Complete Sales Stage
#    Complete Credit Stage  156981  54
#    Complete Processing Stage
#    close browser
#    Delete Robot App
#Create Irving Heavy Fleet Contract
#    [Tags]  New Application
#    Open Application Manager
#    Inital Setup Phase  103  10
#    Add New Contract  8
#    Complete Sales Stage
#    Complete Credit Stage  139558  10
#    Complete Processing Stage
#    close browser
#
#    [Teardown]  Delete Robot App
#Create Irving Light Fleet Contract
#    [Tags]  New Application
#    Open Application Manager
#    Inital Setup Phase  103  10
#    Add New Contract  9
#    Complete Sales Stage
#    Complete Credit Stage  139557  11
#    Complete Processing Stage
#    close browser
#
#    [Teardown]  Delete Robot App




