MARIADB_POD = $(shell kubectl get pods | grep 'mariadb-' | awk '{print $$1}')

.PHONY: skaffold
skaffold:
	skaffold dev

.PHONY: import
import:
	kubectl exec -i $(MARIADB_POD) -- mysql -u root -ptest kirrupt < database.sql

.PHONY: db
sql:
	kubectl exec -it $(MARIADB_POD) -- mysql -u root -ptest kirrupt

all: skaffold
