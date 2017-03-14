set-timezone:
  cmd.run:
    - name: timedatectl set-timezone America/Sao_Paulo
check:
  cmd.run:
    - name: timedatectl
