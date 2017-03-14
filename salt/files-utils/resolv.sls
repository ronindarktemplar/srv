/etc/resolv.conf:
  file.managed:
    - user: root
    - group: root
    - mode:  0644
    - source: salt://files-utils/resolv.conf
