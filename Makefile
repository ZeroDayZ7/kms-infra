NETWORK := kms_spire_net
VOLUMES := spire-agent-socket spire-agent-token spire-server-socket spire-bundle spire-workload spire-server-data spire-agent-data

.PHONY: setup up down logs clean-data

setup:
	@docker network inspect $(NETWORK) >/dev/null 2>&1 || docker network create $(NETWORK)
	@for v in $(VOLUMES); do \
		docker volume inspect $$v >/dev/null 2>&1 || docker volume create $$v; \
	done

up: setup
	docker compose up -d --build

down:
	docker compose down

logs:
	docker compose logs -f --tail=200

clean-data:
	rm -rf spire/server/data/*
