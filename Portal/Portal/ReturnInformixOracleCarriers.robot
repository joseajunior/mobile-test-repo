*** Settings ***
Resource  otr_robot_lib/robot/PortalKeywords.robot

Documentation  This test is to be able to return a set of carriers that can be found in both informix and Oracle
...  Status can equal A for "active" or I for "inactive"
...  carrierlimit can be left out to retrieve a random carrier or use it to return a list of carriers from 2-500


*** Variables ***



*** Test Cases ***

Getting Carriers that are in Informix and Oracle

    ${status}  set variable  A
    ${carrierlimit}  set variable  50       #don't set for more than 1000, that is max amount for find carrier in oracle keyword
    ${carrierlist}  Find Carrier in Oracle  ${status}  TCH  ${carrierlimit}
    ${carrierlist}  evaluate  str(${carrierlist})
    log to console  results: ${carrierlist}

Find Carriers that are in Informix and Oracle with type specified
    [Documentation]  can specify parent_funded or credit and find carrier that exists
    ${status}  set variable  A
    ${carrierlimit}  set variable  50       #don't set for more than 1000, that is max amount for find carrier in oracle keyword
    ${carrierlist}  Find Carrier Types in Oracle  ${status}  TCH  ${carrierlimit}  credit
    ${carrierlist}  evaluate  str(${carrierlist})
    log to console  results: ${carrierlist}




*** Keywords ***
