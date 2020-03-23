.PHONY: import
import:
	docker-compose exec mariadb mysql -u root -ppassword -e "DROP DATABASE IF EXISTS kirrupt"
	docker-compose exec mariadb mysql -u root -ppassword -e "CREATE DATABASE kirrupt"
	docker-compose exec -T mariadb mysql -u root -ppassword kirrupt < database.sql

.PHONY: seed
seed:
	docker-compose exec mariadb mysql -u root -ppassword -e "DROP DATABASE IF EXISTS kirrupt"
	docker-compose exec mariadb mysql -u root -ppassword -e "CREATE DATABASE kirrupt"
	docker-compose exec -T mariadb mysql -u root -ppassword kirrupt < scripts/seed.sql

.PHONY: cypress
cypress:
	make seed
	cd tests/integration/ && CYPRESS_baseUrl=$(URL) ./node_modules/.bin/cypress run

.PHONY: cypress-ci
cypress-ci:
	make seed
	cd tests/integration/ && CYPRESS_baseUrl=http://localhost:$(CI_PORT)/ /node_modules/cypress/bin/cypress run

.PHONY: cypress-dev
cypress-dev:
	make seed
	cd tests/integration/ && CYPRESS_baseUrl=$(URL) ./node_modules/.bin/cypress open

.PHONY: db
sql:
	docker-compose exec mariadb mysql -u root -ppassword kirrupt

.PHONY: check-db
check-db:
	docker-compose exec mariadb mysql -u root -ppassword -e 'select 1'

.PHONY: migrate
migrate:
	docker-compose exec app mix ecto.migrate
