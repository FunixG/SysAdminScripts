#!/bin/sh

echo "Lancement du renouvellement des certificats."
certbot renew --dns-cloudflare --dns-cloudflare-credentials /root/.secrets/certbot/cloudflare.mydomain.ini
