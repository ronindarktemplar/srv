libstdc++-devel:
  pkg:
    - installed
pcre-devel:
  pkg:
    - installed
gd-devel:
  pkg:
    - installed
/etc/cron.daily/sarg-dia.sh:
  file.managed:
    - user: root
    - group: root
    - mode:  0755
    - source: salt://apache/sarg-dia.sh

{% if not salt['file.directory_exists' ]('/etc/sarg') %}
/etc/sarg:
  file.directory:
    - user:  root
    - name:  /etc/sarg
    - group: root
    - mode:  755
{% endif %}

{% if not salt['file.directory_exists' ]('/var/www/html/squid-reports/') %}
/var/www/html/squid-reports/:
  file.directory:
    - user:  root
    - name:  /var/www/html/squid-reports/
    - group: root
    - mode:  755
{% endif %}


/etc/sarg/sarg.conf:
  file.managed:
    - user: root
    - group: root
    - mode:  0644
    - source: salt://apache/sarg.conf

/etc/sarg/exclude_codes:
  file.managed:
    - user: root
    - group: root
    - mode:  0644
    - source: salt://apache/exclude_codes

sarg:
  archive.extracted:
    - name: /usr/local/
    - source: salt://apache/sarg.tar.gz
    - source_hash: md5=f3c5f9a55ffea1662f6ec88daa0c49c3
    - archive_format: tar
    - tar_options: v
    - archive_user: root
    - if_missing: /usr/local/sarg
    - require:
        - pkg: libstdc++-devel
        - pkg: pcre-devel
        - pkg: gd-devel
        - file: /etc/sarg/sarg.conf
        - file: /etc/cron.daily/sarg-dia.sh
