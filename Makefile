.PHONY: import
import:
	docker-compose exec mariadb mysql -u root -ppassword -e "DROP DATABASE IF EXISTS kirrupt"
	docker-compose exec mariadb mysql -u root -ppassword -e "CREATE DATABASE kirrupt"
	docker-compose exec -T mariadb mysql -u root -ppassword kirrupt < database.sql

.PHONY: seed
seed:
	docker-compose exec -T mariadb mysql -u root -ppassword -e "DROP DATABASE IF EXISTS kirrupt"
	docker-compose exec -T mariadb mysql -u root -ppassword -e "CREATE DATABASE kirrupt"
	docker-compose exec -T mariadb mysql -u root -ppassword -e "DROP DATABASE IF EXISTS kirrupt_test"
	docker-compose exec -T mariadb mysql -u root -ppassword -e "CREATE DATABASE kirrupt_test"
	docker-compose exec -T mariadb mysql -u root -ppassword kirrupt < scripts/seed.sql

.PHONY: test
test:
	docker-compose exec -T mariadb mysql -u root -ppassword -e "DROP DATABASE IF EXISTS kirrupt_test"
	docker-compose exec -T mariadb mysql -u root -ppassword -e "CREATE DATABASE kirrupt_test"
	docker-compose run -T test mix test

.PHONY: cypress
cypress:
	make seed
	cd tests/e2e/ && ./node_modules/.bin/cypress run

.PHONY: cypress-docker
cypress-docker:
	make seed
	docker-compose run -T -e CYPRESS_baseUrl=http://tv:8080/ --entrypoint=cypress cypress run

.PHONY: cypress-dev
cypress-dev:
	make seed
	cd tests/e2e/ && ./node_modules/.bin/cypress open

.PHONY: db
db:
	docker-compose exec mariadb mysql -u root -ppassword kirrupt

.PHONY: check-db
check-db:
	docker-compose exec -T mariadb mysql -u root -ppassword -e 'select 1'

.PHONY: migrate
migrate:
	docker-compose exec app mix ecto.migrate
