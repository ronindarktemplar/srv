webmin:
  archive.extracted:
    - name: /opt/
    - source: http://www.webmin.com/download/webmin-current.tar.gz
    - source_hash: md5=e663c3da61c08fc9ecaf1aeab74041e0
    - archive_format: tar
    - tar_options: v
    - archiver_user: root
    - if_missing: /opt/webmin
    - require:
      - pkg: perl-Time-Piece

webmin-files.tar.gz:
  archive.extracted:
    - name: /etc/webmin/
    - source: salt://webmin/webmin-files.tar.gz
    - archive_format: tar
    - tar_options: v
    - archive_user: root
    - if_missing: /opt/webmin

