squid:
  pkg.installed:
    - name: {{ pillar['pkgs']['squid'] }}
  service.running:
    - name: squid
    - enable: True
    - require:
      - file: /etc/squid/squid.conf
      - file: /etc/squid/passwd
      - file: /etc/squid/sites

/etc/squid/squid.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://squid/squid.conf

/etc/squid/squid.conf-fwserver:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://squid/squid.conf-fwserver

/etc/squid/squid.conf-fw:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://squid/squid.conf-fw

/etc/squid/passwd:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://squid/passwd

/etc/squid/sites:
  file.recurse:
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - source: salt://squid/sites

check_if_enabled:
  cmd.run:
    - name: systemctl is-enabled squid.service


