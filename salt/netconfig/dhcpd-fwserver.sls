dhcpd:
  pkg.installed:
    - name: {{ pillar['pkgs']['dhcp'] }}
  service.running:
    - name:  {{ pillar['service']['dhcp-server'] }}
    - enable: True
    - require:
      - file: /etc/dhcp/dhcpd.conf

/etc/dhcp/dhcpd.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://netconfig/dhcpd.conf-fwserver

