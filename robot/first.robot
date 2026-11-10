*** Settings ***
Library    SeleniumLibrary
Test Teardown    Close Browser

*** Variables ***
${URL}        https://www.selenium.dev/selenium/web/web-form.html
${BROWSER}    chrome

*** Test Cases ***
Page Title Is Web Form
    [Documentation]    Open the Selenium practice page and verify its title.
    Open Browser    ${URL}    ${BROWSER}    service=executable_path=r'%{CHROMEDRIVER}'
    Set Window Size    1280    1600
    Title Should Be    Web form
