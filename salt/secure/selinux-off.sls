/etc/sysconfig/selinux:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://secure/selinux
  cmd.run:
    - name: 'setenforce 0'


