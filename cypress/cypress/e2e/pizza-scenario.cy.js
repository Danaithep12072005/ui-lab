// QP-01 A custom pizza reaches the admin list
// Goal: check that a pizza request with restrictions gives a pizza that keeps them,
// that rating a pizza needs a login, and that the admin sees the new pizza.

describe('QP-01 A custom pizza reaches the admin list', () => {
  it('follows the steps of QP-01', () => {
    // Step 1: open QuickPizza and check its heading
    cy.visit('https://quickpizza.grafana.com')
    cy.get('h1')
      .should('have.text', 'Looking to break out of your pizza routine?')

    // Step 2: turn on Advanced and check the four fields
    cy.contains('label', 'Advanced').click()
    cy.contains('label', 'Max Calories per Slice').should('be.visible')
    cy.contains('label', 'Excluded tools').should('be.visible')
    cy.contains('label', 'Must be vegetarian').should('be.visible')
    cy.contains('label', 'Custom Pizza Name').should('be.visible')

    // Step 3: fill the restrictions and a unique pizza name
    const d = new Date()
    const two = (n) => String(n).padStart(2, '0')
    const stamp = d.getFullYear() + two(d.getMonth() + 1) + two(d.getDate()) + '-' +
      two(d.getHours()) + two(d.getMinutes()) + two(d.getSeconds())
    const pizzaName = 'Lab Pizza ' + stamp
    cy.writeFile('results/last-pizza-name.txt', pizzaName)
    cy.contains('label', 'Max Calories per Slice').prev('input').clear().type('600')
    cy.get('select').select('Knife')
    cy.get('#default-checkbox').check({ force: true })
    cy.get('input#pizza-name').clear().type(pizzaName)
    cy.contains('label', 'Max Calories per Slice').prev('input').should('have.value', '600')
    cy.get('select').find('option:selected').should('have.text', 'Knife')
    cy.get('#default-checkbox').should('be.checked')
    cy.get('input#pizza-name').should('have.value', pizzaName)

    // Step 4: ask for a pizza and compare the page with the POST /api/pizza response
    cy.intercept('POST', '/api/pizza').as('pizza')
    cy.get('button[name="pizza-please"]').click()
    cy.wait('@pizza').its('response.statusCode').should('eq', 200)
    cy.get('@pizza').then(({ request, response }) => {
      expect(request.body.maxCaloriesPerSlice).to.equal(600)
      const { pizza, calories } = response.body
      expect(pizza.tool).not.to.equal('Knife')
      expect(calories).to.be.at.most(600)
      cy.contains('#recommendations p', 'Name:')
        .should('have.text', 'Name: ' + pizzaName)
      cy.contains('#recommendations p', 'Tool:')
        .should('have.text', 'Tool: ' + pizza.tool)
      cy.contains('#recommendations p', 'Calories per slice:')
        .should('have.text', 'Calories per slice: ' + calories)
      cy.wrap(pizza.tool).as('tool')
    })
    cy.screenshot('qp01-step4-recommendation')

    // Step 5: rate the pizza without logging in
    cy.get('button[name="rate-5"]').click()
    cy.get('#rate-result').should('have.text', 'Please log in first.')
    cy.screenshot('qp01-step5-login-needed')

    // Step 6: open the admin page and sign in in the same test/browser
    cy.adminLogin('admin', 'admin')
    cy.contains('Latest pizza recommendations').should('be.visible')

    // Step 7: find the new pizza and confirm the same tool
    cy.get('@tool').then((tool) => {
      cy.contains('li', pizzaName).should('contain', '(tool=' + tool + ',')
    })
    cy.screenshot('qp01-step7-admin-list')
  })
})
