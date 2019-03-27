MARIADB_POD = $(shell kubectl get pods | grep 'mariadb-' | awk '{print $$1}')
TV_POD = $(shell kubectl get pods | grep 'tv-' | awk '{print $$1}')
URL = $(shell minikube service ambassador --url)
CI_PORT = $(shell k3s kubectl get service ambassador -o go-template='{{(index .spec.ports 0).nodePort}}')

.PHONY: skaffold
skaffold:
	skaffold dev

.PHONY: import
import:
	kubectl exec -it $(MARIADB_POD) -- mysql -u root -ptest -e "DROP DATABASE IF EXISTS kirrupt"
	kubectl exec -it $(MARIADB_POD) -- mysql -u root -ptest -e "CREATE DATABASE kirrupt"
	kubectl exec -i $(MARIADB_POD) -- mysql -u root -ptest kirrupt < database.sql

.PHONY: seed
seed:
	kubectl exec -it $(MARIADB_POD) -- mysql -u root -ptest -e "DROP DATABASE IF EXISTS kirrupt"
	kubectl exec -it $(MARIADB_POD) -- mysql -u root -ptest -e "CREATE DATABASE kirrupt"
	kubectl exec -i $(MARIADB_POD) -- mysql -u root -ptest kirrupt < scripts/seed.sql
	kubectl exec -it $(MARIADB_POD) -- mysql -u root -ptest kirrupt -e "INSERT INTO users VALUES (NULL,'jdoe','John','Doe','jdoe@example.com','sha1\$$vl7l3\$$5d2a7283730d1fb2afe68a5cc187c819841bd592',1,'2012-04-21 09:40:43','2012-04-21 09:40:43',NULL,NULL,NULL,1,NULL,1,NULL,NULL,NULL,NULL,NULL)"

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
	kubectl exec -it $(MARIADB_POD) -- mysql -u root -ptest kirrupt

.PHONY: check-db
check-db:
	kubectl exec -it $(MARIADB_POD) -- mysql -u root -ptest -e 'select 1'

.PHONY: migrate
migrate:
	kubectl exec -it $(TV_POD) -- mix ecto.migrate

.PHONY: zipkin
zipkin:
	kubectl port-forward $(shell kubectl get pods | grep zipkin | tail -n 1 | awk '{print $$1}') 9411

.PHONY: browser
browser:
	minikube service ambassador

all: skaffold
