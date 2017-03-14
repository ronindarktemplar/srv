# wan 192.168.0.50 com LD 192.168.0.1 (LD vai dar dmz para 192.168.0.50)
# lan 192.168.5.1 (vai dar dhcp para 192.168.5.50 wifiprinc) e mais 5 ips dhcp (caso troca router)
# regras de firewall tramitam entre  interface externa 192.168.0.50 para 192.168.0.1 (LD) e
# -- interface interna  192.168.5.50 (wifiprinc faz nat e rede local eh 192.168.2.0/24
system:
  network.system:
    - enabled: True
    - hostname: fw
    - gateway: 10.0.2.2
#    - gatewaydev: enp0s3
#    - nozeroconf: True
#    - require_reboot: True

enp0s3:
  network.managed:
    - enabled: True
    - type: eth
    - proto: none
    - ipaddr: 10.0.2.15
    - netmask: 255.255.255.0
    - gateway: 10.0.2.2
    - dns:
      - 8.8.8.8
      - 8.8.4.4

enp0s8:
  network.managed:
    - enabled: True
    - type: eth
    - proto: none
    - ipaddr: 192.168.2.102
    - netmask: 255.255.255.0

    
routes:
  network.routes:
    - name: enp0s3
    - routes:
        ipaddr: 10.0.2.0
        netmask: 255.255.255.0
        gateway: 10.0.2.2

