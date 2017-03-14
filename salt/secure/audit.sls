audit:
  pkg.installed:
    - name: audit
  service.dead:
    - name: auditd
    - disable: True

clean:
  cmd.run:
    - name: auditctl -e 0;auditctl -D


