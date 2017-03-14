/usr/local/bin/zerafw.sh:
  file.managed:
    - user: root
    - group: root
    - mode:  0755
    - source: salt://files-utils/zerafw.sh
/usr/local/bin/fw-script.sh:
  file.managed:
    - user: root
    - group: root
    - mode:  0755
    - source: salt://files-utils/fw-script-fw.sh
