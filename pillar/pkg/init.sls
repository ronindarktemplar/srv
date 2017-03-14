pkgs:
    {% if grains['os_family'] == 'RedHat' %}
    apache: httpd
    vim: vim-enhanced
    git: git
    iptables: iptables
    squid: squid
    dhcp: dhcp-server
    {% elif grains['os_family'] == 'Debian' %}
    apache: apache2
    vim: vim
    git: git-core
    iptables: iptables-persistent 
    squid: squid3
    dhcp: dhcp3-server
    {% elif grains['os'] == 'Arch' %}
    apache: apache
    vim: vim
    iptables: iptables
    squid: squid
    dhcp: dhcp
    {% endif %}
