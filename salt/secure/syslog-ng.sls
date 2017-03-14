syslog-ng:
  pkg.installed:
    - name: syslog-ng
  service.running:
    - name: syslog-ng
    - enable: True

check_if_enabled:
  cmd.run:
    - name: systemctl is-enabled syslog-ng.service


