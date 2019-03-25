/// <reference types="Cypress" />

beforeEach(function() {
    cy.login()
})

context('Seasons and episodes', () => {
    it('should show under `shows` and be clickable', () => {
        cy.visit('/')

        cy.contains('shows').click()

        cy.location().should((location) => {
            expect(location.pathname).to.eq('/my-shows')
        })

        // text in show's description
        // todo: This element '<a>' is not visible because it has an effective width and height of: '0 x 0' pixels.
        cy.contains('Downtown Los Angeles', { force: true }).click({ force: true })

        cy.location().should((location) => {
            expect(location.pathname).to.eq('/show/swedish-dicks')
        })
    })

    it('should show latest season', () => {
        cy.visit('/show/swedish-dicks')

        // first, last, and in the middle episodes
        cy.contains('02x01')
        cy.contains('02x06')
        cy.contains('02x10')
    })

    it('should be able to mark it as watched', () => {
        cy.visit('/show/swedish-dicks')

        cy.contains('02x09')
            .parent()
            .contains('.watched_icon', 'Watched')
            .should('have.css', 'color')
            .and('equal', 'rgb(172, 172, 172)')
        cy.contains('02x09').parent().contains('Watched').click()

        cy.contains('02x09')
            .parent()
            .contains('.watched_icon', 'Watched')
            .should('have.css', 'color')
            .and('equal', 'rgb(237, 41, 155)')
        cy.contains('02x09').parent().contains('Watched').click()

        cy.contains('02x09')
            .parent()
            .contains('.watched_icon', 'Watched')
            .should('have.css', 'color')
            .and('equal', 'rgb(172, 172, 172)')
    })

    it('should list episodes in season 1', () => {
        cy.visit('/show/swedish-dicks/season/1')

        cy.contains('01x01')
        cy.contains('01x06')
        cy.contains('01x10')
    })
})