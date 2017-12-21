#!/bin/bash


# limpa as regras das tabelas Filter e NAT
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X

# marcara tudo que vai para a internet
iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE

# encaminhamento de pacotes
echo "1" > /proc/sys/net/ipv4/ip_forward

# politica padão
iptables -P INPUT DROP
iptables -P FORWARD DROP

# aceita pacotes ssh no servidor
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# responde ping
iptables -A INPUT -p icmp -j ACCEPT

# HTTP
iptables -A FORWARD -p tcp --dport 80 -j ACCEPT

# HTTPS
iptables -A FORWARD -p tcp --dport 443 -j ACCEPT

# ping externo
iptables -A FORWARD -p icmp -j ACCEPT

# encaminhamento de pacotes entre os clientes
iptables -A FORWARD -s 192.168.10.0/24 -d 192.168.20.0/24 -j ACCEPT
iptables -A FORWARD -s 192.168.20.0/24 -d 192.168.10.0/24 -j ACCEPT

# aceita ping com o nome do site (www.site.com)
iptables -A FORWARD -p udp --dport 53 -j ACCEPT
iptables -A FORWARD -p udp --sport 53 -j ACCEPT
