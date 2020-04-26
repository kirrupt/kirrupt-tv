/// <reference types="Cypress" />

beforeEach(function() {
    cy.login()
})

context('User show', () => {
    it('find show and add it to my shows', () => {
        cy.visit('/')

        cy.server()
        cy.route('/search?q=Swedish Dicks&**').as('searchResults')

        cy.get('#search_q')
            .type('Swedish Dicks')

        cy.wait('@searchResults')
        cy.contains('Add to my shows').click()

        cy.location().should((location) => {
            expect(location.pathname).to.eq('/show/swedish-dicks')
        })

        // text in show's description
        cy.contains('Downtown Los Angeles')
    })
})
