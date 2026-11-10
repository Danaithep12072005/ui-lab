# W11 UI Lab — Automated UI Testing

Individual lab for ITDS362 Software Quality Assurance and Testing.

## Selected tools
- **Part 3 — Robot Framework** with SeleniumLibrary
- **Part 4 — Cypress**

The work follows `W11-UI_Lab_Exercise_v2.pdf`. Part 0, Section 2, Section 4 and Part B are included; Parts 1 and 2 are intentionally excluded because the exercise requires two selected tools.

## Folder layout
- `robot/` — Robot Framework tests, reusable QuickPizza resource keywords, and two-run evidence.
- `cypress/` — Cypress end-to-end specs, support commands, screenshots and videos.
- `RESULTS.md` — observed environment, manual QP-01, test outcomes, evidence notes and Part B reflection.

## Prerequisites
- Google Chrome
- Python 3.10+
- Node.js 22, 24 or 26
- Git
- For Robot Framework, a ChromeDriver matching the installed Chrome version, stored outside the repository, with `CHROMEDRIVER` set to its full path. On Windows PowerShell, for example: ` $env:CHROMEDRIVER="D:\drivers\chromedriver-win64\chromedriver.exe" `.

## Run Robot Framework
```powershell
cd robot
python -m venv .venv
.venv\Scripts\Activate.ps1
pip install -r requirements.txt
robot --version
robot first.robot
robot web_form.robot
robot -d results/run1 -v BROWSER:headlesschrome pizza_scenario.robot
robot -d results/run2 -v BROWSER:headlesschrome pizza_scenario.robot
```

## Run Cypress
```powershell
cd cypress
npm ci
npx cypress info
npx cypress run --browser chrome
```

See `RESULTS.md` for the measured versions, actual run results, pizza names, timings and evidence.

## Practice sites
- https://www.selenium.dev/selenium/web/web-form.html
- https://quickpizza.grafana.com

## Safety for shared QuickPizza
The tests use unique timestamped pizza names, use the demo `admin` credentials only for the lab login, and never invoke **Clear Ratings**.
