/// <reference types="Cypress" />

beforeEach(function() {
    cy.login()
})

context('Ignore', () => {
    it('should ignore and unignore', () => {
        cy.visit('/show/swedish-dicks')

        // text in show's description
        cy.contains('Downtown Los Angeles')

        cy.contains('Ignore').click()

        cy.contains('Unignore').click()
    })
})