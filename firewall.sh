#!/bin/bash

case "$1" in
	start)
		iptables -F
		iptables -X
		iptables -t nat -F
		iptables -t nat -X

		echo "1" > /proc/sys/net/ipv4/ip_forward

		iptables -A FORWARD -s 192.168.10.0/24 -p tcp --dport 443 -j ACCEPT
		iptables -A FORWARD -s 192.168.20.0/24 -p tcp --dport 443 -j ACCEPT
		iptables -t nat -A PREROUTING -s 192.168.10.0/24 -p tcp --dport 80 -j REDIRECT --to-port 3128
		iptables -t nat -A PREROUTING -s 192.168.10.0/24 -p udp --dport 80 -j REDIRECT --to-port 3128
		iptables -t nat -A PREROUTING -s 192.168.20.0/24 -p tcp --dport 80 -j REDIRECT --to-port 3128
		iptables -t nat -A PREROUTING -s 192.168.20.0/24 -p udp --dport 80 -j REDIRECT --to-port 3128
		
		iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE
	;;
	stop)
		iptables -F
		iptables -X
		iptables -t nat -F
		iptables -t nat -X

		echo "1" > /proc/sys/net/ipv4/ip_forward

		iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE
	;;
	*)
		echo "Parâmetro inválido."
	;;
esac
