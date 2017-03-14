mc:
  pkg:
    - installed
vim-minimal:
  pkg:
    - removed
vim: 
  pkg.installed:
    - name: {{ pillar['pkgs']['vim'] }}
facter:
  pkg:
    - installed
nmap:
  pkg:
    - installed
figlet:
  pkg:
    - installed
gcc:
  pkg:
    - installed
sudo:
  pkg:
    - installed
iftop:
  pkg:
    - installed
iptraf-ng:
  pkg:
    - installed

