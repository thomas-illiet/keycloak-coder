.PHONY: up down logs smoke

up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f keycloak

smoke:
	./scripts/smoke-test.sh

