*** Settings ***
Documentation
...  Intent: This suite covers strictly the Card Report in eManager. The report is downloaded and the content
...  is validated in all formats.

Library  otr_robot_lib.reports.PyPDF
Library  otr_robot_lib.support.PyLibrary

Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.services.GenericService
Library  OperatingSystem  WITH NAME  os
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/ReportKeywords.robot

#Suite Setup  Start Suite
#Suite Teardown  End Test

Force Tags    Reports  Card Report  eManager  teste

*** Variables ***
${filePath}
${DB}  TCH

*** Test Cases ***
Search One Card
    [Tags]  BOT-438  qTest:29025451  qTest:29025954  qTest:29027202  qTest:35303124  qTest:31323582  Regression  refactor  tier:0
    [Setup]  Run Keywords  Define Card and Carrier
    ...      AND  Remove Existing Card Report Files
    Open eManager  ${carrier}  ${validCard.carrier.password}
    Go To Card Report
    Choose Card Number  ${card}
    Choose Format Type  PDF
    Download Report File  CardReport  pdf
    Validate PDF Content  ALL
    [Teardown]  Close Browser

Filter By Policy
    [Tags]  BOT-438  WASBUGGED:INFORMATION DOES NOT APPEAR ON REPORT WHEN IT SHOULD. ALSO INFO SOURCE ALWAYS SHOWS "BOTH". REPORTED.  qTest:29025952  Regression  refactor
    [Setup]  Run Keywords  Define Card and Carrier
    ...      AND  Remove Existing Card Report Files

    Open eManager    ${carrier}  ${validCard.carrier.password}
    Go To Card Report
    Choose Card Number  All
    Match By  Status  ACTIVE
    Match By  Policy Number  2
    Choose Format Type  PDF
    Download Report File  CardReport  pdf
    Validate PDF Content
    ...  Card Number
    ...  X-Ref
    ...  Override
    ...  Policy Number
    ...  Card Status
    ...  Hand Enter
    ...  Information  # THIS IS CURRENTLY BROKEN (SEE LINKED DEFECT IN TAGGED BOT)
    ...  Limits
    [Teardown]  Close Browser

*** Keywords ***
Define Card and Carrier
    Set Test Variable  ${card}  ${validCard.card_num}
    Set Test Variable  ${carrier}  ${validCard.carrier.id}
    Set Test Variable  ${validCard.carrier.password}    ${validCard.carrier.password}

Remove Existing Card Report Files
    @{files}=  os.list directory  ${default_download_path}  *CardReport*
    FOR  ${i}  IN  @{files}
       ${file}=  os.normalize path  ${default_download_path}/${i}
       tch logging  Permanently removing ${file}  WARN
       os.remove file  ${default_download_path}/${i}
    END

Move File To Reports Dir
    close pdf
    #    WE WANT A COPY OF THIS REPORT IN CASE THE SUITE FAILS OR FOR FUTURE REFERENCE.
    os.move file  ${filePath}  ${REPORTSDIR}
    ${newFilePath}=  os.normalize path  ${REPORTSDIR}
    tch logging  File moved to:\n\t${newFilePath}  ALL

Go To Card Report
#    Go to Card Report
    go to  ${emanager}/cards/CardReport.action
#    WAIT UNTIL THE CARD REPORT CONFIGURATION PAGE APPEARS.
    wait until element is visible  //*[@for="cardReport.title.legend"]  timeout=60

Choose Card Number
    [Arguments]  ${card}

#    IF ${card} IS 'ALL' (CASE INSENSITIVE) THEN CHECK THE "All Cards"
#    RADIO BUTTON AND RETURN
    run keyword if  '${card.lower()}'=='all'  run keywords
    ...  click radio button  all  AND
    ...  return from keyword

#    ELSE SEARCH THE CARD.
    click radio button  individualCard
    click on  lookUpCards

#    MASK THE CARD IF IT IS A MASTERCARD.
    ${masked}=  run keyword if  '${card[0]}'=='5'  Mask MasterCard
    ...  ELSE  catenate  ${empty}

#    SEARCH BY CARD AND SELECT THE CARD
    click on  NUMBER
    input text  cardSearchTxt  ${card}
    click on  Look Up Cards
    run keyword if  '${masked}'!='${empty}'
    ...      click on  text=${masked}
    ...  ELSE
    ...     click on  text=${card}

Match By
    [Arguments]  ${key}  ${value}=${None}

#    CHECK THE RADIO BUTTON
    click radio button  //*[text() = "${key}:"]/preceding-sibling::*[1]

#    INPUT/SELECT THE VALUE ASSOCIATED
    ${element}=  catenate
    ...  //*[text() = "${key}:"]/../following-sibling::*[1]
    run keyword if  '${key.lower()}'=='x-ref'
    ...     input text  ${element}/input  ${value}
    ...  ELSE
    ...     select from list by value  ${element}/select  ${value}

Choose Format Type
    [Arguments]  ${format}

    select from list by label  viewFormat  ${format}

Validate PDF Content
    [Arguments]  @{columns}

    @{columns}=  evaluate  [x.lower() for x in ${columns}]

#    CHECK THAT THE FILE EXISTS IN THE DOWNLOADS DIRECTORY
    ${fileExists}=  os.file should exist  ${default_download_path}${/}*CardReport*

#    THERE SHOULD ONLY BE ONE FILE WITH "MoneyCodeUserReport" IN ITS NAME SINCE "INITIATE TEST"
#    DELETED ALL OF THE OTHER ONES IN THE DOWNLOADS DIRECTORY. SO, GET THE ENTIRE FILE NAME...
    ${file}=  os.list directory  ${default_download_path}  *CardReport*.pdf

#    ... NORMALIZE THE PATH WITH APPROPRIATE SEPARATORS AND SUCH ...
    ${filePath}=  os.normalize path  ${default_download_path}${/}${file[0]}
    set global variable  ${filePath}
    tch logging  \nOpening this file: \n\t${filepath}  ALL

#    ... AND OPEN THE PDF USING THE ABSOLUTE PATH TO THE FILE.
    open pdf doc  ${filePath}

    ############################

#    MUST GET THE RAW PDF LAYOUT AND SORT BY COLUMN! SORTING BY COLUMN ALIGNS EVERYTHING PROPERLY
#    TO ENABLE LOOPING THROUGH ROWS.

     get raw pdf layout

#    REMOVE THE COMMENTS BELOW TO VIEW THE PDF TEXT OBJECTS AND COORDINATES ON THE CONSOLE
#     print raw pdf
#     log to console  \n\n\n\n\n

#    GET ALL OF THE CARD NUMBERS IN THE REPORT AS A REFERENCE POINT
    ${cards}=  get column from pdf  23  show_coord=${True}
    ${cards}=  evaluate  [x for x in ${cards} if 'Card Number' not in x]

#    THIS WILL HOLD ALL OF THE ERRORS IF ANY OCCUR.
    @{errors}=  create list

#    GET ALL OF THE ROWS FOR EACH CARD NUMBER
    ${size}=  get list size  ${cards}
    FOR  ${i}  IN RANGE  0  ${size}
       ${cur_row}=  set variable  ${cards[${i}][1]['row']}
       ${next_row}=  run keyword if  ${i+1}==${size}
       ...     set variable  0
       ...  ELSE IF  ${i+1}%4!=0
       ...     set variable  ${cards[${i+1}][1]['row']+10}
       ...  ELSE
       ...     set variable  0
       ${table}=  get pdf table by coordinates
       ...  top=${cur_row}
       ...  bottom=${next_row}
       ...  page_num=${cards[${i}][1]['page']}
       ...  show_coord=${True}
       ${data}=  evaluate
       ...  [x for x in ${table} if x[0] not in ['City', 'State', 'Location', 'Date', 'Type', 'Start', 'Available', 'Used', 'Rolls Over']]
       ${status}  ${message}=  run keyword and ignore error  Validate Card Data  ${data}  @{columns}
       run keyword if  '${status}'=='FAIL'  append to list  ${errors}  ${data[0][0]}:\n\t${message}
    END

    run keyword if  len(${errors})>0  run keywords
    ...  tch logging  Errors occurred in the PDF.  ERROR  AND
    ...  print list  @{errors}  AND
    ...  fail  Errors occurred in the PDF.

Validate Card Data
    [Arguments]  ${data}  @{columns}
    Get Into DB  TCH
    tch logging  Checking card number: ${data[0][0]}  ALL
    ${card_num}=  get card number  ${data[0][0]}
    ${query}=  catenate
    ...  SELECT c.card_num,
    ...         c.coxref,
    ...         c.cardoverride,
    ...         c.icardpolicy,
    ...         CASE c.status
    ...             WHEN 'A' THEN 'ACTIVE'
    ...             WHEN 'I' THEN 'INACTIVE'
    ...             WHEN 'H' THEN 'HOLD'
    ...             ELSE NULL
    ...             END AS status,
    ...         CASE c.handenter
    ...             WHEN 'D' THEN 'POLICY'
    ...             WHEN 'Y' THEN 'ALLOW'
    ...             WHEN 'N' THEN 'DISALLOW'
    ...             ELSE NULL
    ...             END AS handenter,
    ...         CASE c.lmtsrc
    ...             WHEN 'D' THEN 'Policy'
    ...             WHEN 'C' THEN 'Card'
    ...             WHEN 'B' THEN 'Both'
    ...             WHEN 'F' THEN 'Fuel'
    ...             ELSE NULL
    ...             END AS lmtsrc,
    ...         CASE c.infosrc
    ...             WHEN 'D' THEN 'Policy'
    ...             WHEN 'C' THEN 'Card'
    ...             WHEN 'B' THEN 'Both'
    ...             WHEN 'F' THEN 'Fuel'
    ...             ELSE NULL
    ...             END AS infosrc,
    ...         l.city,
    ...         l.state,
    ...         l.name,
    ...         t.trans_date
    ...  FROM cards c,
    ...       TRANSACTION t,
    ...       location l
    ...  WHERE c.card_num = t.card_num
    ...  AND   t.location_id = l.location_id
    ...  AND   c.card_num = '${card_num}'
    ...  ORDER BY t.trans_date DESC limit 1;

    ${queryResults}=  query and strip to dictionary  ${query}

#    CHECK CARD NUMBER IF 'card number' OR 'all' IS PASSED.
    ${i}=  evaluate  0
    run keyword if  'card number' in @{columns} or 'all' in @{columns}
    ...  Check Card Number  ${data[${i}][0]}
    ${i}=  evaluate  ${i}+1

#    CHECK CROSS REFERENCE IF 'x-ref' OR 'all' IS PASSED.
    run keyword if  '${queryResults.coxref}'!='${None}' and ('x-ref' in @{columns} or 'all' in @{columns})
    ...  Check Card Xref  ${data[${i}][0]}  ${queryResults.coxref.strip()}
    ${i}=  run keyword if  '${queryResults.coxref}'!='${None}' and ('x-ref' or 'all' in @{columns})
    ...    evaluate  ${i}+1
    ...  ELSE  set variable  ${i}

#    CHECK OVERRIDES IF 'override' OR 'all' IS PASSED.
    run keyword if  'override' in @{columns} or 'all' in @{columns}
    ...  Check Card Overrides  ${data[${i}][0]}  ${queryResults.cardoverride.strip()}
    ${i}=  evaluate  ${i}+1

#    CHECK POLICY NUMBER IF 'policy number' OR 'all' IS PASSED.
    run keyword if  'policy number' in @{columns} or 'all' in @{columns}
    ...  Check Policy Number  ${data[${i}][0]}  ${queryResults.icardpolicy}
    ${i}=  evaluate  ${i}+1

#    CHECK CARD STATUS IF 'card status' OR 'all' IS PASSED.
    run keyword if  'card status' in @{columns} or 'all' in @{columns}
    ...  Check Status  ${data[${i}][0]}  ${queryResults.status.strip()}
    ${i}=  evaluate  ${i}+1

#    CHECK HAND ENTER IF 'hand enter' OR 'all' IS PASSED.
    run keyword if  'hand enter' in @{columns} or 'all' in @{columns}
    ...  Check Hand Enter  ${data[${i}][0]}  ${queryResults.handenter.strip()}
    ${i}=  evaluate  ${i}+1

#    CHECK PROMPTS IF 'information' OR 'all' IS PASSED.
    run keyword if  'information' in @{columns} or 'all' in @{columns}
    ...  Check Info Source  ${card_num}  ${data[${i}][0]}  ${queryResults.infosrc.strip()}
    ${i}=  run keyword if  'information' in @{columns} or 'all' in @{columns}
    ...     evaluate  ${i}+1
    ...  ELSE
     ...    set variable  ${i}

    ${i}=  run keyword if  'information' in @{columns} or 'all' in @{columns}
    ...     Check Infos  ${data}  ${i}  ${card_num}
    ...  ELSE  set variable  ${i}

#    CHECK LIMITS IF 'limits' OR 'all' IS PASSED.
    run keyword if  'limits' in @{columns} or 'all' in @{columns}
    ...  Check Limit Source  ${card_num}  ${data[${i}][0]}  ${queryResults.lmtsrc.strip()}
    ${i}=  evaluate  ${i}+1

    ${i}=  run keyword if  'limits' in @{columns} or 'all' in @{columns}
    ...     Check Limits  ${data}  ${i}  ${card_num}
    ...  ELSE  set variable  ${i}

Check Card Number
    [Arguments]  ${pdf_card}

#    VALIDATE THAT THE CARD IS MASKED.
    run keyword if  '${pdf_card}'=='5'  run keywords
    ...  should contain  ${pdf_card}  *
    ...  This card is a MasterCard and is not masked!!!
    ...  ${False}
    ...  AND  tch logging  \tThis MasterCard is masked!  ALL
    tch logging  \tCard Number good.  ALL

Check Card Xref
    [Arguments]  ${pdf_xref}  ${db_xref}

#    VALIDATE THE XREF IF IT EXISTS
    should be equal  ${db_xref}  ${pdf_xref}  AND
    tch logging  \tXref good.  ALL

Check Card Overrides
    [Arguments]  ${pdf_override}  ${db_override}

#    VALIDATE OVERRIDES
    should be equal  ${db_override}  ${pdf_override}
    tch logging  \tCard override good.  ALL

Check Policy Number
    [Arguments]  ${pdf_policy}  ${db_policy}

#    VALIDATE POLICY NUMBER
    should be equal as numbers  ${db_policy}  ${pdf_policy}
    tch logging  \tCard policy good.  ALL

Check Status
    [Arguments]  ${pdf_status}  ${db_status}

#    VALIDATE CARD STATUS
    should be equal  ${db_status}  ${pdf_status}
    tch logging  \tCard status good.  ALL

Check Hand Enter
    [Arguments]  ${pdf_handenter}  ${db_handenter}

#    VALIDATE HAND ENTER
    should be equal  ${db_handenter}  ${pdf_handenter}
    tch logging  \tHand enter good.  ALL

Check Info Source
    [Arguments]  ${card_num}  ${pdf_infosrc}  ${db_infosrc}

#    VALIDATE LIMIT SOURCE
    ${infos}=  getRequiredPrompts  ${card_num}
    return from keyword if  bool(${infos})

    should be equal  ${db_infosrc}  ${pdf_infosrc}
    tch logging  \tInfo source good.  ALL

Check Infos
    [Documentation]
    ...  ${i} is the index of the first data element that represents the first limit
    ...  on the pdf for the current card (top to bottom).
    [Arguments]  ${data}  ${i}  ${card_num}


#    VALIDATE THE LIMITS SECTION

    ${infos}=  getRequiredPrompts  ${card_num}
    return from keyword if  bool(${infos})  ${i+1}

    FOR  ${code}  IN  @{infos}
       ${query}=  catenate
       ...  SELECT trim(description) as description
       ...  FROM infos
       ...  WHERE code = '${code}'
       ${info}=  query and strip  ${query}
       should be equal as strings  ${info.lower()}  ${data[${i}][0].strip().lower()}
       ${i}=  evaluate  ${i}+1
       ${today}=  getDateTimeNow  %Y%m%d
       ${val}=  set variable if  '${data[${i}][0].strip()}'!='${today}'  ${data[${i}][0].strip()}  0
       should be equal as numbers  ${infos['${code}']}  ${val}
       ${i}=  evaluate  ${i}+2
    END

    [Return]  ${i}

Check Limit Source
    [Arguments]  ${card_num}  ${pdf_lmtsrc}  ${db_lmtsrc}

#    VALIDATE LIMIT SOURCE
    ${limits}=  get card limits  ${card_num}
    return from keyword if  bool(${limits})

    should be equal  ${db_lmtsrc}  ${pdf_lmtsrc}
    tch logging  \tLimit source good.  ALL

Check Limits
    [Documentation]
    ...  ${i} is the index of the first data element that represents the first limit
    ...  on the pdf for the current card (top to bottom).
    [Arguments]  ${data}  ${i}  ${card_num}


#    VALIDATE THE LIMITS SECTION

    ${limits}=  get card limits  ${card_num}
    return from keyword if  bool(${limits})  ${i+1}

    ${size}=  get list size  ${limits.keys()}
    tch logging  \tSkipping 'Restriction' column...  ALL

    FOR  ${limit}  IN RANGE  0  ${size}
       ${lmt}=  set variable  ${data[${i}][0].split('-')[0]}
       list should contain value  ${limits.keys()}  ${lmt}
       ${i}=  evaluate  ${i}+1
       ${val}=  set variable  ${data[${i}][0].strip('$ ').replace(',','').split('.')[0]}
       should be equal as numbers  ${limits.${lmt}.limit}  ${val}
       ${i}=  evaluate  ${i}+1
       ${pdf_type}=  set variable  ${data[${i}][0]}
       ${query}=  catenate
       ...  SELECT UNIQUE
       ...      CASE
       ...          WHEN fuel_type > 0 AND currency = 'USD' THEN 'GAL'
       ...          WHEN fuel_type > 0 AND currency = 'CAD' THEN 'LTR'
       ...          ELSE currency
       ...      END AS type
       ...  FROM (
       ...  SELECT *
       ...  FROM contract c,
       ...       def_card d,
       ...       cards ca
       ...  WHERE c.contract_id = d.contract_id
       ...  AND   c.carrier_id = ca.carrier_id
       ...  AND   d.ipolicy = ca.icardpolicy
       ...  AND   ca.card_num = '${card_num.strip()}'),
       ...  (SELECT *
       ...  FROM products
       ...  WHERE restriction_group = '${lmt}'
       ...  AND fps_partner = '${DB.upper()}')
       ${type}=  query and strip  ${query}
       should be equal as strings  ${pdf_type}  ${type.strip()}
       ${i}=  evaluate  ${i}+1
       tch logging  \tCard limit (${lmt}) good.  ALL
       ${i}=  evaluate  ${i}+1
    END

    [Return]  ${i}