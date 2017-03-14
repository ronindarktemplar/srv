save-rules:
  cmd.run:
    - name: iptables-save > {{ pillar['paths']['iptables'] }};ip6tables-save > {{ pillar['paths']['ip6tables'] }}

#salt '*' iptables.save /etc/sysconfig/iptables

#salt '*' iptables.save /etc/sysconfig/iptables family=ipv6

#salt '*' iptables.get_saved_rules

#salt '*' iptables.get_saved_rules family=ipv6
