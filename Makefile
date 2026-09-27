NETWORK := kms_spire_net
VOLUMES := spire-agent-socket spire-agent-token spire-server-socket spire-bundle spire-workload spire-server-data spire-agent-data

.PHONY: setup up down logs clean reset

setup:
	@docker network inspect $(NETWORK) >/dev/null 2>&1 || docker network create $(NETWORK)
	@for v in $(VOLUMES); do \
		docker volume inspect $$v >/dev/null 2>&1 || docker volume create $$v; \
	done
	@docker volume inspect kms_sockets >/dev/null 2>&1 || docker volume create kms_sockets
	@docker volume inspect spire_sockets >/dev/null 2>&1 || docker volume create spire_sockets

up: setup
	docker compose up -d --build

down:
	docker compose down --remove-orphans

clean:
	@docker compose down --remove-orphans || true
	@for v in $(VOLUMES); do \
		docker volume rm -f $$v >/dev/null 2>&1 || true; \
	done
	@docker volume rm -f kms_sockets >/dev/null 2>&1 || true
	@docker volume rm -f spire_sockets >/dev/null 2>&1 || true
	@docker network rm $(NETWORK) >/dev/null 2>&1 || true

reset: clean setup
	docker compose up -d --build

logs:
	docker compose logs -f --tail=200