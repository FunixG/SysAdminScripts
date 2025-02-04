#!/bin/bash

# Liste des pays à bloquer (codes ISO Alpha-2)
COUNTRIES="af ba cf cn hk id ir kp kr ro ru sg sk za tz tr tm ae vn in"

# Vérification et installation d'IPset et iptables si absent
echo "[INFO] Vérification des paquets requis..."
sudo apt update -y
sudo apt install -y ipset iptables

# Création de l'ensemble IPset pour stocker les IPs à bloquer
echo "[INFO] Création de l'IPset blacklist..."
sudo ipset destroy blacklist 2>/dev/null
sudo ipset create blacklist hash:net

# Téléchargement des plages IP des pays à bloquer
echo "[INFO] Téléchargement des plages IP..."
for country in $COUNTRIES; do
    echo "[INFO] Ajout des IPs pour le pays: $country"
    wget -O - http://www.ipdeny.com/ipblocks/data/countries/$country.zone 2>/dev/null | while read ip; do
        sudo ipset add blacklist $ip
    done
done

# Ajout d'une règle iptables pour bloquer les IPs de la blacklist
echo "[INFO] Application des règles iptables..."
sudo iptables -I INPUT -m set --match-set blacklist src -j DROP

# Sauvegarde des règles pour qu'elles persistent après reboot
echo "[INFO] Sauvegarde des règles..."
sudo ipset save > /etc/ipset.rules
sudo iptables-save > /etc/iptables/rules.v4

# Charger automatiquement les règles au démarrage
if ! grep -q "ipset restore < /etc/ipset.rules" /etc/rc.local; then
    echo "ipset restore < /etc/ipset.rules" | sudo tee -a /etc/rc.local
    echo "iptables-restore < /etc/iptables/rules.v4" | sudo tee -a /etc/rc.local
    chmod +x /etc/rc.local
fi

echo "[INFO] Blocage terminé avec succès ! 🚀"
