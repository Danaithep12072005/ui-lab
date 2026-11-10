// Log in on the QuickPizza admin page with a user name and password.
Cypress.Commands.add('adminLogin', (user, password) => {
  cy.visit('https://quickpizza.grafana.com/admin')
  // The form works only after the page script has started.
  cy.get('#svelte-announcer').should('exist')
  // The page fills both boxes with admin, so clear them first.
  cy.get('#username').clear().type(user)
  cy.get('#password').clear().type(password)
  cy.get('button[type="submit"]').click()
})
