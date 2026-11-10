# UI lab results

Student: Danaithep
Course: ITDS362 — Software Quality Assurance and Testing
Tool parts that I chose: **Part 3 — Robot Framework** and **Part 4 — Cypress**
Source: `W11-UI_Lab_Exercise_v2.pdf`, Version 2.0, revision 4 November 2026

## Part 0: Getting ready

- Step 0.1, Chrome version: **156.0.8078.80** (Windows x64, installed on MAN).
- Step 0.3, ChromeDriver version: **156.0.8078.80**.
- ChromeDriver location (outside the repository): `D:\drivers\chromedriver-win64\chromedriver.exe`.
- `CHROMEDRIVER`: set as a User environment variable to the path above. It was also set in the Robot test process environment.
- Step 0.4, stable locators checked and used:
  - Pizza, Please! button: `button[name="pizza-please"]`
  - Excluded tools list: `select` / `css:select`
  - Must be vegetarian checkbox: `#default-checkbox`
  - Custom Pizza Name input: `input#pizza-name`
  - Max Calories per Slice input: `xpath://label[contains(.,'Max Calories')]/../input` (label-based because the page repeats the same id on its three number inputs).
- Step 0.5, browser-run QP-01 data (the two automation runs also validate these expected results):
  - Pizza name: `Lab Pizza 20261110-174833`
  - Excluded tool: `Knife`
  - Recommended tool: `Scissors`
  - Calories per slice: `575` (at most 600)
  - Vegetarian checkbox: selected

| Step | Actual result observed in the browser | Pass or fail |
|------|---------------------------------------|--------------|
| 1 | QuickPizza heading displayed: “Looking to break out of your pizza routine?” | PASS |
| 2 | Advanced fields displayed: Max Calories per Slice, Excluded tools, Must be vegetarian and Custom Pizza Name | PASS |
| 3 | Values shown: 600 calories, Knife excluded, vegetarian checked, unique Lab Pizza name | PASS |
| 4 | Recommendation kept the name and restrictions; example result Scissors, 575 calories per slice | PASS |
| 5 | Clicking Love it! without login displayed “Please log in first.” | PASS |
| 6 | Admin login succeeded and “Latest pizza recommendations” appeared | PASS |
| 7 | Admin list contained the new pizza and the same tool, Scissors | PASS |

Note: The step results above were observed during the automated browser runs. A separate manual mouse-and-keyboard execution of QP-01 was not performed by the remote test process.

## Part 3: Robot Framework

- Python: **3.14.7**
- Robot Framework: **7.5.1**
- SeleniumLibrary: **6.9.0**
- Selenium: **4.52.0**
- Step 3.2 wrong-title failure message: `Title should have been 'Wrong title' but was 'Web form'.` The expected title was restored to `Web form` and the positive test passed.
- Basic tests: `first.robot` and `web_form.robot` both passed (1 test each).
- Step 3.8 run 1: **PASS**, elapsed **10.211260 s**, pizza `Lab Pizza 20261110-174821`.
- Step 3.8 run 2: **PASS**, elapsed **9.508869 s**, pizza `Lab Pizza 20261110-174833`.
- Each full run has `log.html`, `report.html`, `output.xml`, and four screenshots in its own folder.
- Evidence: `robot/results/run1/` and `robot/results/run2/`.

## Part 4: Cypress

- Node.js: **v24.11.0**
- npm: **11.6.1**
- Cypress package and binary: **16.2.1**
- Browser: **Chrome 156 (headless)**
- Step 4.3 wrong-title failure: `Timed out retrying after 10000ms`; expected `Wrong title`, actual `Web form`. The expected title was restored and the spec passed.
- Step 4.6, POST `/api/pizza` response observed in the recommendation: tool **Scissors**, calories **550** in the retained full-run screenshot. The test also asserts the request limit is 600, the tool is not Knife, and calories are at most 600.
- Step 4.7: the admin list line showed `Lab Pizza 20261110-175317 (tool=Scissors, ...)`.
- Step 4.8 run 1: **PASS**, QP-01 **8,811 ms**, pizza `Lab Pizza 20261110-175244`; both specs passed, total **00:15**.
- Step 4.8 run 2: **PASS**, QP-01 **8,851 ms**, pizza `Lab Pizza 20261110-175317`; both specs passed, total **00:15**.
- The two specs are `pizza-scenario.cy.js` and `web-form.cy.js`; each full run passed 2/2 tests.
- Step 4.9 (optional): not run in a second browser; the required runs used Chrome.
- Evidence: `cypress/cypress/videos/`, `cypress/cypress/screenshots/`, and per-run pizza names in `cypress/results/run1/` and `cypress/results/run2/`.

## Part B: Reflection

### 1. Why the calories field uses its label instead of its id

The page gives the three number inputs the same id, `floating_filled`, so selecting that id does not identify the Max Calories per Slice field uniquely. The label text identifies the correct input by its position relative to the label. The page could give this input a unique id such as `max-calories-per-slice`. A unique id would make the locator shorter and less dependent on the page layout, and it would be easier to maintain in both Robot Framework and Cypress.

### 2. Test oracle in QP-01 step 7

Step 7 uses a consistency (relational) test oracle: it compares the tool shown in the admin list with the tool returned in the recommendation in step 4. It would catch a fault where the admin list saves or displays a different tool from the one QuickPizza actually recommended. The check is stronger than merely confirming that the pizza name exists, because it verifies that the related data stayed consistent across the customer and admin views.

### 3. Checking that the pizza is vegetarian

The test could inspect the ingredients in the recommendation and assert that every ingredient is marked vegetarian. The current test only checks that the vegetarian checkbox is selected, which proves the request was entered but not that the recommendation obeyed it. To make the assertion reliable, the page or the API response would need to expose the ingredient list and a trusted vegetarian classification for each ingredient (or an explicit `isVegetarian` result). The test could then fail if even one non-vegetarian ingredient appears.

### 4. Comparing Robot Framework and Cypress

Robot Framework uses explicit SeleniumLibrary waits such as `Wait Until Element Is Visible` and `Wait Until Page Contains`, while Cypress retries element queries and assertions automatically for up to the configured 10 seconds. Robot's resource keywords made the seven QP-01 steps read like the written test case, and its HTML log/report clearly show keyword details and screenshots. Cypress required less explicit waiting code and its Command Log plus video made the browser actions easy to follow. Cypress was quicker to run here, while Robot's reusable resource file made the locator and page actions especially easy to organize.

### 5. Tool choice for Project 2

I would choose Cypress for Project 2. First, its automatic retry behavior reduces the need to write and maintain explicit waits for pages that render asynchronously. Second, its videos and screenshots provide clear evidence of the complete UI flow, and the same Cypress test can compare the API response with what the page displays. The two full Chrome runs both passed, which also gave evidence that the timestamped test data avoids collisions.

### 6. Robot Framework locator maintenance

If the calories locator changes, I would update `${MAX CALORIES}` in `robot/resources/quickpizza.resource`. The test case in `pizza_scenario.robot` calls the resource keyword `Fill In The Pizza Request` and does not contain the page locator itself. Keeping the locator in one resource file means the repair is made once and the test steps remain readable. This is the page-object/keyword approach practised in Part 3.

### 7. Why Cypress keeps QP-01 in one test

Cypress clears cookies before each test, and QuickPizza uses a cookie to keep a browser connected to the same server. QP-01 creates the pizza on the customer page and then checks that pizza on the admin page, so both parts must run in the same test and browser session. If steps 6 and 7 were a second test, Cypress would clear the cookie before it began and the admin page could connect to a different server. The new pizza might then be missing from that server's admin list, causing a false failure.