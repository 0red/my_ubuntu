# Redirect incoming connexion to port 80 on the web server

iptables -t nat -A PREROUTING -p tcp -d $FIREWALL_INT_IP --dport 80 -j DNAT --to-destination $SERVER_INT_IP:80
iptables -t nat -A POSTROUTING -p tcp -d $SERVER_INT_IP -j SNAT --to $FIREWALL_INT_IP
iptables -A FORWARD -p tcp -i eth0 -d $SERVER_INT_IP --dport 80 -j ACCEPT
iptables -A FORWARD -p tcp -o eth0 -s $SERVER_INT_IP --sport 80 -j ACCEPT



iptables -t nat -A PREROUTING -p tcp -d 192.168.100.235 --dport 80 -j DNAT --to-destination 192.168.2.235:80
iptables -t nat -A POSTROUTING -p tcp -d 192.168.2.235 -j SNAT --to 192.168.100.235
iptables -A FORWARD -p tcp -i br_lan -d 192.168.2.235 --dport 80 -j ACCEPT
iptables -A FORWARD -p tcp -o br_lan -s 192.168.2.235 --sport 80 -j ACCEPT


iptables -t nat -A PREROUTING -p tcp -d 192.168.100.235 --dport 5432 -j DNAT --to-destination 192.168.2.235:5432
iptables -t nat -A POSTROUTING -p tcp -d 192.168.2.235 -j SNAT --to 192.168.100.235
iptables -A FORWARD -p tcp -i br_lan -d 192.168.2.235 --dport 5432 -j ACCEPT
iptables -A FORWARD -p tcp -o br_lan -s 192.168.2.235 --sport 5432 -j ACCEPT
