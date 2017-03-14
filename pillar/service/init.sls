service:
    {% if grains['os_family'] == 'RedHat' %}
    apache: httpd
    iptables: iptables
    squid: squid
    dhcp-server:  dhcpd
    {% elif grains['os_family'] == 'Debian' %}
    apache: apache2
    iptables: iptables
    squid: squid3
    dhcp-server:  dhcpd
    {% elif grains['os'] == 'Arch' %}
    apache: apache
    iptables: iptables
    squid: squid
    dhcp-server:  dhcpd
   {% elif grains['os'] == 'Windows' %}
    apache: Apache
    iptables: iptables
    squid: Squid
    dhcp-server:  "DHCP Server"
    {% endif %}
