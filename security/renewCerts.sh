#!/bin/sh

echo "Arrêt de apache2."
systemctl stop apache2

echo "Lancement du renouvellement des certificats."
certbot renew --dns-cloudflare --dns-cloudflare-credentials /root/.secrets/certbot/cloudflare.mydomain.ini

echo "Relancement de apache2."
systemctl start apache2
