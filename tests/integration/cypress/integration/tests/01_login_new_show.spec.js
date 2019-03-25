/// <reference types="Cypress" />

context('Login and add show', () => {
    it('should login and redirect to front page', () => {
        cy.visit('/account/login')

        cy.get('#login_username')
            .type('jdoe')

        cy.get('#login_password')
            .type('test')

        cy.get('button[type=submit]').click()

        cy.location().should((location) => {
            expect(location.pathname).to.eq('/')
        })

        cy.contains('jdoe')
    })

    it('should add new show', () => {
        cy.login()

        cy.visit('/my-shows')

        cy.contains('Add new show').click()

        cy.location().should((location) => {
            expect(location.pathname).to.eq('/show/add')
        })

        // we need TV show with at least 2 seasons
        // but not much episodes, to not download
        // too many images every time
        cy.get('#add_name')
            .type('Swedish Dicks')

        cy.get('input[type=submit]').click()

        cy.get('.recent_episode').contains('b', 'Swedish Dicks').parent().click()
    })
})