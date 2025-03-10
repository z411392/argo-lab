include .env
export

.PHONY: connect disconnect install uninstall reinstall up down restart

connect-%:
	@envsubst < ./setup/repositories/$*.yaml | kubectl apply -f -

connect: \
	connect-root \
	connect-istio \
	connect-knative \
	connect-bitnami \
	connect-kubeservice-stack

disconnect-%:
	@envsubst < ./setup/repositories/$*.yaml | kubectl delete -f -

disconnect: \
	disconnect-kubeservice-stack \
	disconnect-bitnami \
	disconnect-knative \
	disconnect-istio \
	disconnect-root

install-%:
	@envsubst < ./infra/$*.yaml | kubectl apply -f -

install: \
	install-istio \
	install-rabbitmq \
	install-knative

# install: \
	install-istio \
	install-rabbitmq \
	install-knative \
	install-monitoring \
	install-elasticsearch \
	install-db

uninstall-%:
	@envsubst < ./infra/$*.yaml | kubectl delete -f -

uninstall: \
	uninstall-knative \
	uninstall-rabbitmq \
	uninstall-istio

# uninstall: \
	uninstall-db \
	uninstall-elasticsearch \
	uninstall-monitoring \
	uninstall-knative \
	uninstall-rabbitmq \
	uninstall-istio

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