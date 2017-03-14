apache:
  pkg.installed:
    - name: {{ pillar['pkgs']['apache'] }}
  service.running:
    - name:  {{ pillar['service']['apache'] }}
    - enable: True
    - require:
      - file: /etc/httpd/conf/httpd.conf

/etc/httpd/conf/httpd.conf:
  file.managed:
    - user: root
    - group: root
    - mode:  0644
    - source: salt://apache/httpd.conf-fw



