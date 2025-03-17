include .env
export

.PHONY: \
	connect disconnect \
	install uninstall reinstall \
	up down restart \
	install-debezium uninstall-debezium reinstall-debezium \
	install-tools uninstall-tools reinstall-tools

.ONE_SHELL:

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

install: \
	install-rabbitmq \
	install-knative \
	install-db
	@DB_HOST=db-mysql.db.svc \
		envsubst < ./infra/phpmyadmin.yaml | kubectl apply -f -

install-debezium:
	@DB_HOST=db-mysql.db.svc \
	DB_PORT=3306 \
	DB_USER=root \
	DB_PASSWORD=$(shell kubectl get secret db-mysql -n db -o jsonpath='{.data.mysql-root-password}'|base64 -d) \
	AMQP_HOST=$(shell kubectl get secret rabbitmq-default-user -n amqp -o jsonpath='{.data.host}'|base64 -d) \
	AMQP_PORT=$(shell kubectl get secret rabbitmq-default-user -n amqp -o jsonpath='{.data.port}'|base64 -d) \
	AMQP_USER=$(shell kubectl get secret rabbitmq-default-user -n amqp -o jsonpath='{.data.username}'|base64 -d) \
	AMQP_PASSWORD=$(shell kubectl get secret rabbitmq-default-user -n amqp -o jsonpath='{.data.password}'|base64 -d) \
	AMQP_VHOST=/ \
		envsubst < ./infra/debezium.yaml | kubectl apply -f -

install-tools: \
	install-monitoring \
	install-elasticsearch

install-%:
	@envsubst < ./infra/$*.yaml | kubectl apply -f -

uninstall: \
	uninstall-phpmyadmin \
	uninstall-db \
	uninstall-knative \
	uninstall-rabbitmq

uninstall-tools: \
	uninstall-elasticsearch \
	uninstall-monitoring \

uninstall-debezium:
	@envsubst < ./infra/debezium.yaml | kubectl delete -f -

uninstall-%:
	@envsubst < ./infra/$*.yaml | kubectl delete -f -

reinstall: uninstall install
reinstall-debezium: uninstall-debezium install-debezium
reinstall-monitoring: uninstall-monitoring install-monitoring

up-%:
	@envsubst < ./setup/projects/$*.yaml | kubectl apply -f -

up: \
	up-default

down-%:
	@envsubst < ./setup/projects/$*.yaml | kubectl delete -f -

down: \
	down-default

restart: down up