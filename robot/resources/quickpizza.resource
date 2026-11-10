*** Settings ***
Library    SeleniumLibrary
Library    String

*** Variables ***
${QUICKPIZZA}       https://quickpizza.grafana.com
${HEADING}          css:h1
${BROWSER}          chrome
${MAX CALORIES}    xpath://label[contains(.,'Max Calories')]/../input

*** Keywords ***
Open QuickPizza
    [Documentation]    QP-01 step 1. Open the home page and wait for its heading.
    Open Browser    ${QUICKPIZZA}    ${BROWSER}    service=executable_path=r'%{CHROMEDRIVER}'
    Set Window Size    1280    1600
    Wait Until Element Is Visible    ${HEADING}
    Element Text Should Be    ${HEADING}    Looking to break out of your pizza routine?

Turn On Advanced
    [Documentation]    QP-01 step 2. Show the advanced fields.
    Click Element    xpath://label[.//span[normalize-space()='Advanced']]
    Wait Until Page Contains Element    xpath://option[.='Knife']
    Element Should Be Visible    ${MAX CALORIES}
    Element Should Be Visible    css:select
    Element Should Be Visible    id:default-checkbox
    Element Should Be Visible    css:input#pizza-name

Fill In The Pizza Request
    [Documentation]    QP-01 step 3. Type the restrictions and the name.
    [Arguments]    ${calories}    ${tool}    ${name}
    Input Text    ${MAX CALORIES}    ${calories}
    Select From List By Label    css:select    ${tool}
    Select Checkbox    id:default-checkbox
    Input Text    css:input#pizza-name    ${name}
    Textfield Value Should Be    ${MAX CALORIES}    ${calories}
    List Selection Should Be    css:select    ${tool}
    Checkbox Should Be Selected    id:default-checkbox
    Textfield Value Should Be    css:input#pizza-name    ${name}

Recommendation Should Keep The Restrictions
    [Documentation]    QP-01 step 4. Check the pizza name, excluded tool and calorie limit.
    [Arguments]    ${name}
    Click Element    css:button[name="pizza-please"]
    Wait Until Page Contains    Name: ${name}
    ${tool_line}=    Get Text    xpath://div[@id='recommendations']//p[starts-with(normalize-space(), 'Tool:')]
    ${tool}=    Fetch From Right    ${tool_line}    Tool:
    ${tool}=    Strip String    ${tool}
    Should Not Be Equal    ${tool}    Knife
    ${calorie_line}=    Get Text    xpath://div[@id='recommendations']//p[starts-with(normalize-space(), 'Calories per slice:')]
    ${calories}=    Fetch From Right    ${calorie_line}    Calories per slice:
    ${calories}=    Convert To Integer    ${calories}
    Should Be True    ${calories} <= 600    Calories per slice was ${calories}
    RETURN    ${tool}

Rate The Pizza Without Logging In
    [Documentation]    QP-01 step 5. Rating without a login must ask the user to log in.
    Click Element    css:button[name="rate-5"]
    Wait Until Element Contains    id:rate-result    Please log in first.

Log In As Admin
    [Documentation]    QP-01 step 6. Open admin in the same browser and sign in.
    [Arguments]    ${username}    ${password}
    Go To    ${QUICKPIZZA}/admin
    Wait Until Page Contains Element    id:svelte-announcer
    Input Text    id:username    ${username}
    Input Password    id:password    ${password}
    Click Button    css:button[type="submit"]
    Wait Until Page Contains    Latest pizza recommendations

Admin List Should Show The Pizza
    [Documentation]    QP-01 step 7. Find the pizza and its tool.
    [Arguments]    ${name}    ${tool}
    Wait Until Page Contains    ${name}
    Element Should Contain    xpath://li[contains(.,'${name}')]    ${tool}



