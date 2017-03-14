iptables-services:
  pkg.installed
iptables: 
  pkg.installed:
    - name: {{ pillar['pkgs']['iptables'] }}
  service.running:
    - enable: = True
    - require:
      - pkg: iptables-services
      - file: /etc/sysconfig/iptables
      - file: /etc/sysconfig/ip6tables

/etc/sysconfig/iptables:
  file.managed:
    - name:  {{ pillar['paths']['iptables'] }}
    - user: root
    - group: root
    - mode: 644
    - source: salt://myfw/iptables-clean

/etc/sysconfig/ip6tables:
  file.managed:
    - name:  {{ pillar['paths']['ip6tables'] }}
    - user: root
    - group: root
    - mode: 644
    - source: salt://myfw/ip6tables-clean

