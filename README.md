# KMS SPIRE Infra

To repozytorium infrastruktury SPIRE oddzielonej od aplikacji KMS.

## Cel

Uruchamia stack SPIRE z serwerem, agentem, inicjalizacją wpisów i workloadem tak, aby aplikacja Rust mogła korzystać z:

- gniazda agenta: `/tmp/spire-agent.sock`
- certyfikatów workload: `/run/spire/workload`
- bundle trust: `/run/spire/workload/bundle.pem`

## Wymagania

- Docker Engine
- Docker Compose v2

## Przygotowanie wspólnych zasobów

```bash
docker network inspect kms_spire_net >/dev/null 2>&1 || docker network create kms_spire_net
docker volume inspect spire-agent-socket >/dev/null 2>&1 || docker volume create spire-agent-socket
docker volume inspect spire-workload >/dev/null 2>&1 || docker volume create spire-workload
docker volume inspect spire-bundle >/dev/null 2>&1 || docker volume create spire-bundle
docker volume inspect spire-agent-token >/dev/null 2>&1 || docker volume create spire-agent-token
docker volume inspect spire-server-socket >/dev/null 2>&1 || docker volume create spire-server-socket
```

## Uruchomienie

```bash
docker compose up -d --build
```

## Kontrola

```bash
docker compose ps
docker compose logs -f spire-server
docker compose logs -f spire-agent
```

## Stop

```bash
docker compose down
```

## Uwagi architektoniczne

- repo to jest czysto infrastrukturalne
- aplikacja KMS pozostaje w osobnym repozytorium
- sockety i wolumeny są wspólne z kontenerami aplikacji przez sieć `kms_spire_net` oraz wolumeny Docker
