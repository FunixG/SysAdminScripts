#!/bin/sh

# Bloquer les paquets invalides
iptables -t mangle -A PREROUTING -m conntrack --ctstate INVALID -j DROP

# Bloquer les paquets non-SYN en état NEW
iptables -t mangle -A PREROUTING -p tcp ! --syn -m conntrack --ctstate NEW -j DROP

# Bloquer MSS suspect
iptables -t mangle -A PREROUTING -p tcp -m conntrack --ctstate NEW -m tcpmss ! --mss 536:65535 -j DROP

# Bloquer les paquets avec flags TCP suspects
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL NONE -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j DROP

# Limiter le ping pour éviter les floods
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/s --limit-burst 5 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

# Bloquer les attaques UDP
iptables -A INPUT -p udp -m conntrack --ctstate NEW -m limit --limit 10/s --limit-burst 20 -j ACCEPT
iptables -A INPUT -p udp -m conntrack --ctstate NEW -j DROP

# Activer TCP SYN cookies pour se protéger des SYN floods
echo 1 > /proc/sys/net/ipv4/tcp_syncookies
iptables -A INPUT -p tcp --syn -m limit --limit 100/s --limit-burst 200 -j ACCEPT
iptables -A INPUT -p tcp --syn -j DROP

# Bloquer les connexions simultanées excessives
iptables -A INPUT -p tcp -m connlimit --connlimit-above 50 -j DROP

# Bloquer les paquets fragmentés
iptables -t mangle -A PREROUTING -f -j DROP

# Protection brute-force SSH
iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --set
iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --update --seconds 60 --hitcount 10 -j DROP

# Protection contre les scans de ports
iptables -N port-scanning
iptables -A port-scanning -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s --limit-burst 2 -j RETURN
iptables -A port-scanning -j DROP
