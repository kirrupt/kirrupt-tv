/// <reference types="Cypress" />

beforeEach(function() {
    cy.login()
})

context('Time wasted', () => {
    it('should be able to mark it as watched', () => {
        cy.visit('/show/swedish-dicks')

        cy.server()
        cy.route('/episode/**').as('markAsWatched')

        cy.contains('02x08')
            .parent()
            .contains('.watched_icon', 'Watched')
            .should('have.css', 'color')
            .and('equal', 'rgb(172, 172, 172)')
        cy.contains('02x08').parent().contains('Watched').click()

        cy.contains('02x07')
            .parent()
            .contains('.watched_icon', 'Watched')
            .should('have.css', 'color')
            .and('equal', 'rgb(172, 172, 172)')
        cy.contains('02x07').parent().contains('Watched').click()

        cy.contains('02x06')
            .parent()
            .contains('.watched_icon', 'Watched')
            .should('have.css', 'color')
            .and('equal', 'rgb(172, 172, 172)')
        cy.contains('02x06').parent().contains('Watched').click()

        Cypress._.times(3, () => {
            cy.wait('@markAsWatched')
        })
    })

    it('should be able to mark all as watched', () => {
        cy.visit('/show/swedish-dicks')

        cy.contains('list').click()

        cy.server()
        cy.route('/episode/**').as('markAsWatched')

        cy.contains('mark all').click()

        // Cypress doesn't handle concurrent requests
        // (for the same resource) correctly.
        // It would detect random number of requests
        // between 1 and 10.
        //
        // Cypress._.times(10, () => {
        //     cy.wait('@markAsWatched')
        // })

        cy.wait(30000)
    })

    it('should show correct time wasted', () => {
        cy.visit('/')

        cy.contains('time wasted').click()

        cy.contains('6 hours, 30 minutes')
    })
})