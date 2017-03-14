webmin-1.810:
  archive.extracted:
    - name: /opt/
    - source: http://www.webmin.com/download/webmin-current.tar.gz
    - source_hash: md5=e663c3da61c08fc9ecaf1aeab74041e0
    - archive_format: tar
    - tar_options: v
    - archive_user: root
    - if_missing: /opt/webmin-1.810
    - require:
      - pkg: perl-Time-Piece
