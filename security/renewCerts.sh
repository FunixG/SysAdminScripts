#!/bin/sh

echo "Arrêt de apache2."
systemctl stop apache2

echo "Lancement du renouvellement des certificats."
certbot renew

echo "Relancement de apache2."
systemctl start apache2