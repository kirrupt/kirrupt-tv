/// <reference types="Cypress" />

beforeEach(function() {
    cy.login()
})

context('User show', () => {
    it('find show and add it to my shows', () => {
        cy.visit('/')

        cy.get('#search_q')
            .type('Swedish Dicks')

        cy.contains('Add to my shows').click({ timeout: 60000 })

        cy.location().should((location) => {
            expect(location.pathname).to.eq('/show/swedish-dicks')
        })

        // text in show's description
        cy.contains('Downtown Los Angeles')
    })
})
