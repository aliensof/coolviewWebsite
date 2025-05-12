#!/bin/bash

# Domain for the certificate
DOMAIN="coolview.co"

# Directories for certificate and key
CERT_DIR="/etc/letsencrypt/live/$DOMAIN"
CLIENT_CERT_DIR="/var/lib/docker/volumes/coolview-client-nginx-certificates/_data"
SERVER_CERT_DIR="/var/lib/docker/volumes/coolview-server-certificates/_data"

cp "$CERT_DIR/fullchain.pem" "$CLIENT_CERT_DIR/$DOMAIN.crt"
cp "$CERT_DIR/privkey.pem" "$CLIENT_CERT_DIR/$DOMAIN.key"
cp "$CERT_DIR/fullchain.pem" "$SERVER_CERT_DIR/$DOMAIN.crt"
cp "$CERT_DIR/privkey.pem" "$SERVER_CERT_DIR/$DOMAIN.key"

# renew certificates in containers
docker exec -it coolview_client nginx -s reload
docker restart coolview_server