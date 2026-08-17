FROM quay.io/keycloak/keycloak:26.7.0

COPY --chown=keycloak:keycloak theme/coder /opt/keycloak/themes/coder

