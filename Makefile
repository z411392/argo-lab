include .env
export

.PHONY: \
	connect disconnect \
	install uninstall reinstall \
	up down restart

connect-%:
	@envsubst < ./setup/repositories/$*.yaml | kubectl apply -f -

connect: \
	connect-root \
	connect-knative \
	connect-bitnami

disconnect-%:
	@envsubst < ./setup/repositories/$*.yaml | kubectl delete -f -

disconnect: \
	disconnect-bitnami \
	disconnect-knative \
	disconnect-root

install-%:
	@envsubst < ./infra/$*.yaml | kubectl apply -f -

# install: \
# 	install-rabbitmq \
# 	install-knative

install: \
	install-rabbitmq \
	install-knative \
	install-monitoring \
	install-elasticsearch \
	install-db

uninstall-%:
	@envsubst < ./infra/$*.yaml | kubectl delete -f -

# uninstall: \
# 	uninstall-knative \
# 	uninstall-rabbitmq

uninstall: \
	uninstall-db \
	uninstall-elasticsearch \
	uninstall-monitoring \
	uninstall-knative \
	uninstall-rabbitmq

reinstall: uninstall install

up-%:
	@envsubst < ./setup/projects/$*.yaml | kubectl apply -f -

up: \
	up-default

down-%:
	@envsubst < ./setup/projects/$*.yaml | kubectl delete -f -

down: \
	down-default

restart: down up