#!/bin/bash

# Domain for the certificate
DOMAIN="coolview.co"

# Directories for certificate and key
CERT_DIR="/etc/letsencrypt/live/$DOMAIN"
DEPLOY_HOOK_DIR="/etc/letsencrypt/renewal-hooks/deploy"
CLIENT_CERT_DIR="/var/lib/docker/volumes/coolview-client-nginx-certificates/_data"
SERVER_CERT_DIR="/var/lib/docker/volumes/coolview-server-certificates/_data"

# Run Certbot to obtain the certificate
sudo certbot certonly --webroot -w /var/lib/docker/volumes/coolview-client-certbot/_data/ -d $DOMAIN

# If Certbot successfully obtained the certificate
if [ $? -eq 0 ]; then
    # Rename and copy the certificate and key files
    cp "$CERT_DIR/fullchain.pem" "$CLIENT_CERT_DIR/$DOMAIN.crt"
    cp "$CERT_DIR/privkey.pem" "$CLIENT_CERT_DIR/$DOMAIN.key"
    cp "$CERT_DIR/fullchain.pem" "$SERVER_CERT_DIR/$DOMAIN.crt"
    cp "$CERT_DIR/privkey.pem" "$SERVER_CERT_DIR/$DOMAIN.key"

    # copy deployhook
    cp "lets_encrypt_renew_hook.sh" "$DEPLOY_HOOK_DIR"

    # Restart containers
    docker restart coolview_client
    docker restart coolview_server

    echo "Certificate successfully obtained and copied."
else
    echo "Failed to obtain the certificate. Check Certbot logs for more details."
fi