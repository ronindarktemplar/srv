# wan 192.168.0.50 com LD 192.168.0.1 (LD vai dar dmz para 192.168.0.50)
# lan 192.168.5.1 (vai dar dhcp para 192.168.5.50 wifiprinc) e mais 5 ips dhcp (caso troca router)
# regras de firewall tramitam entre  interface externa 192.168.0.50 para 192.168.0.1 (LD) e
# -- interface interna  192.168.5.50 (wifiprinc faz nat e rede local eh 192.168.2.0/24
system:
  network.system:
    - enabled: True
    - hostname: fwserver
    - gateway: 192.168.0.1
#    - gatewaydev: enp0s3
#    - nozeroconf: True
#    - require_reboot: True

enp3s0:
  network.managed:
    - enabled: True
    - type: eth
    - proto: none
    - ipaddr: 192.168.0.50
    - netmask: 255.255.255.0
    - gateway: 192.168.0.1
    - dns:
      - 8.8.8.8
      - 8.8.4.4

enp5s0:
  network.managed:
    - enabled: True
    - type: eth
    - proto: none
    - ipaddr: 192.168.5.1
    - netmask: 255.255.255.0

    
routes:
  network.routes:
    - name: enp0s3
    - routes:
        ipaddr: 192.168.0.0
        netmask: 255.255.255.0
        gateway: 192.168.0.1

