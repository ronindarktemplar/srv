rsync_allow:
    iptables.insert:
      - position: 1
      - table: filter 
      - chain: INPUT
      - jump: ACCEPT
      - dport: 873
      - proto: tcp
      - source: '192.168.1.0/24'
      - save: True

