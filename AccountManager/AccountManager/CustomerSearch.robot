*** Settings ***
Library  DateTime
Library  BuiltIn
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.support.PyLibrary
Library  String
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Suite Setup  Open Account Manager
Suite Teardown  close all browsers

Force Tags  AM  refactor

Documentation  Those are the carrier ranges found on the Wiki:
...     0              99999          3 (IMPERIAL)
...     100000        200000          0 (TCH)
...     200001        299999          2 (IRVING)
...     300000        389999          0 (TCH)
...     390000        399999          6 (PNC)
...     400000        449999          1 (SHELL)
...     450000        499999          0
...     500000        649999          1 (SHELL)
...     650000        699999          0
...     700000        849999          0 (FLEET 1)
...     850000        899999          2 (IRVING)
...     950000        997999          3 (IMPERIAL)
...     998000        999999          5 (HUSKY)
...     1000000        1999999        0 (RV Card (TCH))
...     2000000        2999999        4
...     3000000        4999999        0 (TCH Mastercard)

*** Variables ***

*** Test Cases ***
Search for an EFS carrier
    [Tags]  JIRA:BOT-1498  qTest:30703848  Regression
    [Documentation]  This is to test if an account manager can pull an EFS carrier
    ${carrier}  Get A Valid Carrier  TCH  300000  389999
    Search a carrier in Account Manager  EFS  ${carrier}

Search for an Irving carrier
    [Tags]  JIRA:BOT-1499  qTest:31958002  Regression
    [Documentation]  This is to test if an account manager can pull an Irving carrier
    ${carrier}  Get A Valid Carrier  IRVING  200001  299999
    Search a carrier in Account Manager  IRVING_OIL  ${carrier}

Search for a Shell carrier
    [Tags]  JIRA:BOT-1500  qTest:31958019  Regression
    [Documentation]  This is to test if an account manager can pull a Shell carrier
    ${carrier}  Get A Valid Carrier  SHELL  500000  649999
    Search a carrier in Account Manager  SHELL_CANADA  ${carrier}

Search for an invalid carrier
    [Tags]  JIRA:BOT-1501  qTest:31958063  Regression
    [Documentation]  This is to test that an account manager should not be able to pull an invalid carrier

    ${status}=  run keyword and return status  search a carrier in account manager  EFS  11111
    should not be true  ${status}  My Invalid Carrier Somehow Pulled up in Account Manager which is weird


Search for an Imperial carrier
    [Tags]  JIRA:BOT-1502  qTest:31958025  Regression
    [Documentation]  This is to test if an account manager can pull an Imperial carrier
    ${carrier}  Get A Valid Carrier  IMPERIAL  950000  997999
    Search a carrier in Account Manager  IMPERIAL_OIL  ${carrier}

Search for an PNC carrier
    [Tags]  JIRA:BOT-1503  qTest:31958033  Regression  refactor
    [Documentation]  This is to test if an account manager can pull a PNC carrier
    ${carrier}  Get A Valid Carrier  TCH  390000  399999
    Search a carrier in Account Manager  PNC  ${carrier}

Search for a Husky carrier
    [Tags]  JIRA:BOT-1504  qTest:31958062  Regression  refactor
    [Documentation]  This is to test if an account manager can pull a Husky carrier
    ${carrier}  Get A Valid Carrier    IMPERIAL  998000  999999
    Search a carrier in Account Manager  HUSKY  ${carrier}

Search for an YCP carrier
    [Tags]  JIRA:BOT-1505  qTest:31958046  Regression  refactor
    [Documentation]  This is to test if an account manager can pull a YCP carrier
    ${carrier}  Get A Valid Carrier  TCH  4000000  4999999
    Search a carrier in Account Manager  YELLOWCARD  ${carrier}


*** Keywords ***

Get A Valid Carrier
    [Arguments]  ${DB}  ${begin_range}  ${end_range}

    Get Into DB  ${DB}
    ${carrier}  Query And Strip  SELECT member_id FROM member WHERE status='A' AND member_id BETWEEN '${begin_range}' AND '${end_range}' LIMIT 1

    [Return]  ${carrier}