paths:
    {% if grains['os_family'] == 'RedHat' %}
    iptables: /etc/sysconfig/iptables    
    ip6tables: /etc/sysconfig/ip6tables    
    {% elif grains['os_family'] == 'Debian' %}
    iptables: /etc/iptables/rules.v4
    ip6tables: /etc/iptables/rules.v6 
    {% elif grains['os'] == 'Arch' %}
    iptables: /etc/iptables/iptables.rules
    ip6tables: /etc/iptables/ip6tables.rules
    {% endif %}
