/// <reference types="Cypress" />

beforeEach(function() {
    cy.login()
})

context('Table listing', () => {
    it('should list table', () => {
        cy.visit('/show/swedish-dicks')

        cy.contains('list').click()

        cy.contains('01x01')
        cy.contains('01x06')
        cy.contains('01x10')

        cy.contains('02x01')
        cy.contains('02x06')
        cy.contains('02x10')
    })
})