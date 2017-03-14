base:
  '*':
    - mytools
  'minion1':
    - files-utils
    - secure
    - myfw
  'fw':
    - files-utils
    - files-utils.zerafw-fw
    - netconfig.eths-fw
    - netconfig.dhcpd-fw
    - secure
    - squid
    - webmin
    - apache
    - apache.apache-fw
    - myfw
    - myfw.myiptables-fw
  'fwserver':
    - files-utils
    - files-utils.zerafw-fwserver
    - netconfig.eths-fwserver
    - netconfig.dhcpd-fwserver
    - secure
    - squid
    - webmin
    - apache
    - apache.apache-fwserver
    - myfw
    - myfw.myiptables-fwserver
  'harumi'
    - win.repo.salt-winrepo_git.7zip
