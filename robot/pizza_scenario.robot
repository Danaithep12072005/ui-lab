*** Settings ***
Documentation        Test case QP-01, A custom pizza reaches the admin list.
Resource             resources/quickpizza.resource
Test Teardown        Close Browser
Library              DateTime

*** Test Cases ***
QP-01 A Custom Pizza Reaches The Admin List
    [Documentation]    A pizza request with restrictions gives a pizza that keeps them, rating needs a login, and the admin sees the pizza.
    # Step 1: open QuickPizza and check its heading
    Open QuickPizza

    # Step 2: turn on Advanced and check the four fields
    Turn On Advanced

    # Step 3: fill the restrictions and unique pizza name
    ${stamp}=    Get Current Date    result_format=%Y%m%d-%H%M%S
    ${name}=    Set Variable    Lab Pizza ${stamp}
    Fill In The Pizza Request    600    Knife    ${name}
    Capture Page Screenshot    qp01-step3-fields.png

    # Step 4: request a pizza and check the recommendation
    ${tool}=    Recommendation Should Keep The Restrictions    ${name}
    Capture Page Screenshot    qp01-step4-recommendation.png

    # Step 5: rate the pizza without logging in
    Rate The Pizza Without Logging In
    Capture Page Screenshot    qp01-step5-login-needed.png

    # Step 6: open the admin page and sign in
    Log In As Admin    admin    admin

    # Step 7: find the new pizza and confirm the same tool
    Admin List Should Show The Pizza    ${name}    ${tool}
    Capture Page Screenshot    qp01-step7-admin-list.png
