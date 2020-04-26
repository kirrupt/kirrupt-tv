/// <reference types="Cypress" />

context('Register, login and add show', () => {
    it('should login and redirect to front page', () => {
        cy.visit('/')

        cy.contains('register').click()

        cy.get('#user_first_name')
            .type('John')

        cy.get('#user_last_name')
            .type('Doe')

        cy.get('#user_username')
            .type('jdoe')

        cy.get('#user_password')
            .type('test')

        cy.get('#user_password_confirmation')
            .type('test')

        cy.get('#user_email')
            .type('jdoe@example.com')

        cy.get('#user_accept_tos').check()

        cy.get('button[type=submit]').click()

        cy.contains('Password should be at least')

        cy.get('#user_password')
            .type('test1234')

        cy.get('#user_password_confirmation')
            .type('test1234')

        cy.get('#user_accept_tos').check()

        cy.get('button[type=submit]').click()

        cy.location().should((location) => {
            expect(location.pathname).to.eq('/')
        })

        cy.contains('jdoe')
    })

    it('should login and redirect to front page', () => {
        cy.visit('/account/login')

        cy.get('#login_username')
            .type('jdoe')

        cy.get('#login_password')
            .type('test1234')

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