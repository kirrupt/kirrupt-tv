MARIADB_POD = $(shell kubectl get pods | grep 'mariadb-' | awk '{print $$1}')
TV_POD = $(shell kubectl get pods | grep 'tv-' | awk '{print $$1}')

.PHONY: skaffold
skaffold:
	skaffold dev

.PHONY: import
import:
	kubectl exec -i $(MARIADB_POD) -- mysql -u root -ptest kirrupt < database.sql

.PHONY: seed
seed:
	kubectl exec -i $(MARIADB_POD) -- mysql -u root -ptest kirrupt < scripts/seed.sql

.PHONY: db
sql:
	kubectl exec -it $(MARIADB_POD) -- mysql -u root -ptest kirrupt

.PHONY: empty-db
empty-db:
	kubectl exec -it $(TV_POD) -- mix ecto.migrate

.PHONY: add-test-user
add-test-user:
	kubectl exec -it $(MARIADB_POD) -- mysql -u root -ptest kirrupt -e "INSERT INTO users VALUES (NULL,'jdoe','John','Doe','jdoe@example.com','sha1\$$vl7l3\$$5d2a7283730d1fb2afe68a5cc187c819841bd592',1,'2012-04-21 09:40:43','2012-04-21 09:40:43',NULL,NULL,NULL,1,NULL,1,NULL,NULL,NULL,NULL,NULL)"

.PHONY: zipkin
zipkin:
	kubectl port-forward $(shell kubectl get pods | grep zipkin | tail -n 1 | awk '{print $$1}') 9411

.PHONY: browser
browser:
	minikube service ambassador

all: skaffold
